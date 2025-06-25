function [T_fin] = MakeTrainingSequence(P)
%%
% read excel files with image name and category
% in case of indoor scene stimuli (bedroom/living room/kitchen) additional
% ratings of typicality available, typicality ratings serve as criterion of
% selection 
stim_training_idx   = readtable(P.stim_140);
stim_targets_idx    = readtable(P.stim_target);
stim_nontargets_idx = readtable(P.stim_nontarget);
stim_training       = table2struct(stim_training_idx);
stim_targets        = table2struct(stim_targets_idx);
stim_nontargets     = table2struct(stim_nontargets_idx);
stim_training       = struct('info', stim_training);
stim_targets        = struct('info', stim_targets);
stim_nontargets     = struct('info', stim_nontargets);

%%
% get info for room categories for standard stimuli
% stim_select = struct([]);
% for icat = 1:length(P.scene_categories)
%     cat_name = P.scene_categories{icat};
%     cat_idx  = strcmp(stim_training.category, cat_name);
%     cat_tab  = stim_training(cat_idx,:);
%     cat_struct = table2struct(cat_tab);
%     stim_select(icat).info = cat_struct;
% 
%     typicality_median(icat) = median([stim_select(icat).info.p_typicality]);
% end


%%
T = struct();

% idx_standard   = find(strcmp([stim_training_idx.category], 'standard'));
% idx_targets    = find(strcmp([stim_targets_idx.category], 'target'));
% idx_nontargets = find(strcmp([stim_nontargets_idx.category], 'nontarget'));
% 
idx_standard   = find(strcmp({stim_training.info.category}, 'standard'));
idx_targets    = find(strcmp({stim_targets.info.category}, 'target'));
idx_nontargets = find(strcmp({stim_nontargets.info.category}, 'nontarget'));


itrial = 0;
block_cat_total = 1;

for icat = 1:length(P.scene_categories)

    % idx_standard   = find(strcmp([stim_training.info.category], 'standard'));
    % idx_targets    = find(strcmp([stim_targets.info.category], 'target'));
    % idx_nontargets = find(strcmp([stim_nontargets.info.category], 'nontarget'));


    for i_cat_block = 1:P.nblocks_per_category

        % Select standard images.
        [itrial, T, idx_standard, block_cat_total] = get_images(itrial, T, stim_training, idx_standard, i_cat_block, block_cat_total, P.n_standard);

        % Select target images.
        [itrial, T, idx_targets, block_cat_total] = get_images(itrial, T, stim_targets, idx_targets, i_cat_block, block_cat_total, P.n_target);

        % Select nontarget images.
        [itrial, T, idx_nontargets, block_cat_total] = get_images(itrial, T, stim_nontargets, idx_nontargets, i_cat_block, block_cat_total, P.n_nontarget);

        block_cat_total = block_cat_total + 1;
        
    end
end


%% 
% find all already used images in oddball task in order to include them in
% and to not use them again and select new foils for the memory task


for icat = 1:length(P.scene_categories)

    % Names of all images.
    all_cat_imgs = {stim_training(icat).info.stimulus};

    idx_cat = strcmp({T.category}, P.scene_categories{icat});
    used_cat_imgs = {T(idx_cat).filename};

    available_imgs = find(~ismember(all_cat_imgs, used_cat_imgs));

    stim_available(icat).info = stim_training(icat).info(available_imgs);
end

%%
% get new images/foils for the memory task

M = struct();

itrial = 0;
block_mem_total = 1;

idx_standard_mem   = find(strcmp({stim_available.info.category}, 'standard'));

for imem = 1:length(P.scene_categories)

    for i_mem_block = 1:P.nblocks_per_category

        % Select standard images.
        [itrial, M, idx_standard, block_mem_total]   = get_images_mem(itrial, M, stim_available, idx_standard_mem, i_mem_block, block_mem_total, P.n_standard);

        block_mem_total = block_mem_total + 1;
       
    end
end

%%
% struct for memory task, including images of oddball task plus new foils
T_C = T;
allCatnames = {T_C.category};
idxDel = contains(allCatnames, 'target');
T_C(idxDel) = [];
T_C = struct2table(T_C);
T_C.task = strrep(T_C.task, 'oddball', 'memory');
T_C = table2struct(T_C);
T_C = T_C.';

T_C = cell2struct(struct2cell(T_C), {'filename', 'category', 'p_typicality', 'n_block', 'task', 'cond', 'block_total'});
TM = [T_C, M];


%%
% UNTIL NOW FINAL VERSION OF MEMORY TASK
% Randomization of memory task structure

% Create keys for grouping based on category and block_mem_total
groupKeys = strcat(string({TM.category})', "_", string([TM.block_total]'));

% Get unique keys and initialize cell array to hold each group
[uniqueKeys, ~, groupIndices] = unique(groupKeys);
groupedStruct = cell(length(uniqueKeys), 1);

% Group and randomize within each group
for i = 1:length(uniqueKeys)
    % Get entries in the current group
    groupMembers = TM(groupIndices == i);
    
    % Randomize order within the group
    randIdx = randperm(length(groupMembers));
    groupedStruct{i} = groupMembers(randIdx);
end

% Randomize the order of the groups themselves
randGroupOrder = randperm(length(groupedStruct));
groupedStruct = groupedStruct(randGroupOrder);

% Concatenate all randomized groups into a single struct
%randomizedStruct = vertcat(groupedStruct{:});
randomizedStruct = horzcat(groupedStruct{:});



%%
% Randomization of oddball task structure (NEWEST VERSION)

% Convert struct to table for easier processing
T_table = struct2table(T);

% Get unique blocks and shuffle them
blocks = unique(T_table.block_total);
shuffledBlockOrder = blocks(randperm(length(blocks)));

% Final output as struct array
finalStruct = [];
finalIndex = 1;

for i = 1:length(shuffledBlockOrder)
    block_rows = T_table(T_table.block_total == shuffledBlockOrder(i), :);

    % Randomize the rows in this block
    block_rows = block_rows(randperm(height(block_rows)), :);

    % Attempt to reorder this block with constraints
    reordered_block = reorder_block_with_constraints(block_rows);

    % Convert to struct and store
    block_struct = table2struct(reordered_block);
    block_struct = block_struct.';
    finalStruct = [finalStruct, block_struct];
   
end


% --- Function to reorder a block avoiding category adjacency conflicts ---
function ordered = reorder_block_with_constraints(tbl)
    max_attempts = 1000;
    for attempt = 1:max_attempts
        shuffled = tbl(randperm(height(tbl)), :);
        if is_valid_order(shuffled.category)
            ordered = shuffled;
            return;
        end
    end
    error('Could not satisfy category ordering constraints after %d attempts', max_attempts);
end

% --- Function to check for consecutive category violations ---
function valid = is_valid_order(category)
    valid = true;
    for i = 2:length(category)
        prev = category{i-1};
        curr = category{i};
        if strcmp(prev, 'target') && strcmp(curr, 'target')
            valid = false; return;
        elseif strcmp(prev, 'nontarget') && strcmp(curr, 'nontarget')
            valid = false; return;
        elseif (strcmp(prev, 'target') && strcmp(curr, 'nontarget')) || ...
               (strcmp(prev, 'nontarget') && strcmp(curr, 'target'))
            valid = false; return;
        end
    end
end
%%

% Combine both structures into one array
allStructs = [finalStruct, randomizedStruct];

% Extract all block_total values
allBlockTotals = [allStructs.block_total];

% Get unique block_total values in sorted order
uniqueBlocks = unique(allBlockTotals);

% Randomize the order of block_total groups
randOrder = uniqueBlocks(randperm(length(uniqueBlocks)));

% Initialize combined structure
T_fin = struct([]);

% Index for combinedStruct
idx = 1;

% Loop through each unique block_total value
for i = 1:length(randOrder)
    currentBlock = randOrder(i);

    % Find matching elements in structA
    aMatch = finalStruct([finalStruct.block_total] == currentBlock);
    
    % Find matching elements in structB
    bMatch = randomizedStruct([randomizedStruct.block_total] == currentBlock);

    % Combine them
    group = [aMatch, bMatch];

    T_fin = [T_fin, group];

    % Add to combined structure
    % for j = 1:length(group)
    %     combinedStruct(idx) = group(j);
    %     idx = idx + 1;
    % end
end


end
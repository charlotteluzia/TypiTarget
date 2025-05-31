
%%
% read excel files with image name and category
% in case of indoor scene stimuli (bedroom/living room/kitchen) additional
% ratings of typicality available, typicality ratings serve as criterion of
% selection 
stim_140        = readtable(P.stim_140);
%match           = wildcardPattern + '/';
%stim_140        = erase(stim_140.stimulus, match);
stim_targets_idx    = readtable(P.stim_target);
stim_nontargets_idx = readtable(P.stim_nontarget);
stim_targets        = table2struct(stim_targets_idx);
stim_nontargets     = table2struct(stim_nontargets_idx);
stim_targets        = struct('info', stim_targets);
stim_nontargets     = struct('info', stim_nontargets);

%%
% get info for room categories for standard stimuli
stim_select = struct([]);
for icat = 1:length(P.scene_categories)
    cat_name = P.scene_categories{icat};
    cat_idx = strcmp(stim_140.category, cat_name);
    cat_tab = stim_140(cat_idx,:);
    cat_struct = table2struct(cat_tab);
    stim_select(icat).info = cat_struct;

    typicality_median(icat) = median([stim_select(icat).info.p_typicality]);
end


%%
T = struct();

idx_targets    = find(strcmp([stim_targets_idx.category], 'target'));
idx_nontargets = find(strcmp([stim_nontargets_idx.category], 'nontarget'));

%idx_targets    = find(strcmp([stim_targets_new.info.category], 'target'));
%idx_nontargets = find(strcmp([stim_nontargets.category], 'nontarget'));


itrial = 0;
block_cat_total = 1;

for icat = 1:length(P.scene_categories)

    idx_typ   = find([stim_select(icat).info.p_typicality]  > typicality_median(icat));
    idx_untyp = find([stim_select(icat).info.p_typicality] <= typicality_median(icat));


    for i_cat_block = 1:P.nblocks_per_category

        % Select typical images.
        [itrial, T, idx_typ, block_cat_total]   = get_images(itrial, T, stim_select(icat), idx_typ, i_cat_block, block_cat_total, P.n_typ);

        % Select untypical images.
        [itrial, T, idx_untyp, block_cat_total] = get_images(itrial, T, stim_select(icat), idx_untyp, i_cat_block, block_cat_total, P.n_untyp);

        % Select target images.
        [itrial, T, idx_targets, block_cat_total] = get_images(itrial, T, stim_targets, idx_targets, i_cat_block, block_cat_total, P.n_target);

        % Select nontarget images.
        [itrial, T, idx_nontargets, block_cat_total] = get_images(itrial, T, stim_nontargets, idx_nontargets, i_cat_block, block_cat_total, P.n_nontarget);

        block_cat_total = block_cat_total + 1;
        
    end



end

%% HIER WIRD JETZT GESHUFFLED
% BLA

for itrial = 1:length(T)
    T.(itrial).trial = itrial;

    double_target = 1;
    double_nontarget = 1;
    
    while double_target == 1 | double_nontarget == 1
    
        T = shuffle(T);
    
        category = [T.category];
    
        is_target    = strcmp(category, 'target');
        is_nontarget = strcmp(category, 'nontarget');
    
        double_target    = any(diff(is_target) == 0 & is_target(1:end-1) == 1);
        double_nontarget = any(diff(is_nontarget) == 0 & is_nontarget(1:end-1) == 1);


    end
end

%% Shufflen

for i = 1:length(T)

    if T(i).block_cat_total == T(i).block_cat_total
        
        T
    end

end

%% Memory task

M = struct();

% all_target_imgs = {stim_targets.info.stimulus};
% idx_tar         = strcmp({T.category}, 'target');
% 
% used_target_imgs            = {T(idx_tar).filename};
% available_imgs_targets      = find(~ismember(all_target_imgs, used_target_imgs));
% stim_available_targets.info = stim_targets.info(available_imgs_targets);
% 
% all_nontarget_imgs = {stim_nontargets.info.stimulus};
% idx_nontar         = strcmp({T.category}, 'nontarget');
% 
% used_nontarget_imgs            = {T(idx_nontar).filename};
% available_imgs_nontargets      = find(~ismember(all_nontarget_imgs, used_nontarget_imgs));
% stim_available_nontargets.info = stim_nontargets.info(available_imgs_nontargets);


for icat = 1:length(P.scene_categories)

    % Names of all images.
    all_cat_imgs = {stim_select(icat).info.stimulus};

    idx_cat = strcmp({T.category}, P.scene_categories{icat});
    used_cat_imgs = {T(idx_cat).filename};

    available_imgs = find(~ismember(all_cat_imgs, used_cat_imgs));

    stim_available(icat).info = stim_select(icat).info(available_imgs);
end
%%

%idx_targets    = find(strcmp([stim_targets_idx.category], 'target'));
%idx_nontargets = find(strcmp([stim_nontargets_idx.category], 'nontarget'));


itrial = 0;
block_mem_total = 1;

for imem = 1:length(P.scene_categories)

    % is it ok to calculate new median at this stage? or should median be
    % same for all available images out of dataset, not just for available
    % images after "using" some
    idx_typ   = find([stim_available(imem).info.p_typicality]  > typicality_median(imem));
    idx_untyp = find([stim_available(imem).info.p_typicality] <= typicality_median(imem));



    for i_mem_block = 1:P.nblocks_per_category

        % Select typical images.
        [itrial, M, idx_typ, block_mem_total]   = get_images_mem(itrial, M, stim_available(imem), idx_typ, i_mem_block, block_mem_total, P.n_typ);

        % Select untypical images.
        [itrial, M idx_untyp, block_mem_total] = get_images_mem(itrial, M, stim_available(imem), idx_untyp, i_mem_block, block_mem_total, P.n_untyp);

        block_mem_total = block_mem_total + 1;

       
    end

    %itrial =  itrial
    % itrial = itrial setzen, um weiter zu zaehlen und schon gezeigte images
    % in oddbal/cat an struct M dranzuhaengen
end

%%
% struct for memory task, including images of oddball task plus new foils

allCatnames = {T.category};
idxDel = contains(allCatnames, 'target');
T(idxDel) = [];

T = cell2struct(struct2cell(T), {'filename', 'category', 'p_typicality', 'mem_block', 'task', 'block_mem_total'});
TM = [T, M];

% shuffle images within their indoor scene category (bedroom/living room/kitchen)
% get index of each image within category to shuffle within 
% category has to match and block of image was shown in/was "member" of

for imem = 1%:length(P.scene_categories)
    for ii = 1:length(P.scene_categories)*P.nblocks_per_category


    idx_cat_mem = strcmp({TM.category},  P.scene_categories{imem}) & [TM.block_mem_total] == ii;
    end
end


to_shuffle = struct([]);
for ii = 1:length(P.scene_categories)*P.nblocks_per_category

    idx_cat_mem = find([TM.block_mem_total] == ii);
 

end

%%
% Randomization of memory task structure

% Extract unique groups based on category and block_mem_total
uniqueGroups = unique([string({TM.category})', [TM.block_mem_total]'], 'rows');

% Initialize randomized struct
randomizedStruct = [];

for i = 1:size(uniqueGroups, 1)
    % Get current group values
    currentCategory = uniqueGroups(i, 1);
    currentBlockMem = str2double(uniqueGroups(i, 2));
    
    % Find matching entries
    matches = arrayfun(@(x) strcmp(string(x.category), currentCategory) && x.block_mem_total == currentBlockMem, TM);
    
    % Extract group and randomize
    group = TM(matches);
    randIdx = randperm(length(group));
    randomizedGroup = group(randIdx);
    
    % Append to final randomized struct
    randomizedStruct = [randomizedStruct, randomizedGroup];
end


%%
% UNTIL NOW FINAL VERSION OF MEMORY TASK
% Randomization of memory task structure

% Create keys for grouping based on category and block_mem_total
groupKeys = strcat(string({TM.category})', "_", string([TM.block_mem_total]'));

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
% Randomization of oddball task structure

% Create keys for grouping based on category and block_mem_total
catKeys = unique([T.block_cat_total]);

% Get unique keys and initialize cell array to hold each group
% [uniqueCatKeys, ~, groupIndices] = unique(catKeys);
% groupedCatStruct = cell(length(uniqueCatKeys), 1);



% Group and randomize within each group
for i = 1%:length(catKeys)
    % Get entries in the current group
    % CatgroupMembers = (T.block_cat_total == i);

    matching = arrayfun(@(x) x.block_cat_total == i, T);
    CatgroupMembers = T(matching);
    double_target = 1;
    double_nontarget = 1;
    
    while double_target == 1 | double_nontarget == 1
        % Randomize order within the group
        randIdx = randperm(length(CatgroupMembers));
        %groupedCatStruct{i} = CatgroupMembers(randIdx);
        randomizedCatGroup = CatgroupMembers(randIdx);
        %CatgroupMembers = shuffle(CatgroupMembers);
    
        % condition of targets not following targets or nontargets and
        % nontargets not following nontargets or targets
        % no T-T, T-N, N-N, N-T combinations
        is_target    = strcmp([randomizedCatGroup.category], 'target');
        is_nontarget = strcmp([randomizedCatGroup.category], 'nontarget');
        
        double_target    = any(diff(is_target) == 0 & is_target(1:end-1) == 1);
        double_nontarget = any(diff(is_nontarget) == 0 & is_nontarget(1:end-1) == 1);
    end

end


%%
% Randomization of oddball task structure

% % Convert struct to table for easier manipulation (if needed)
% T_table = struct2table(T);
% 
% % Get unique block categories
% blocks = unique(T_table.block_cat_total);
% numBlocks = length(blocks);
% 
% % Create a randomized order of blocks
% shuffledBlockOrder = blocks(randperm(numBlocks));
% 
% finalStruct = struct(); % Preallocate empty struct
% blockCounter = 1;
% 
% for i = 1:numBlocks
%     % Get rows for this block
%     blockRows = T_table(T_table.block_cat_total == shuffledBlockOrder(i), :);
% 
%     % Randomize block rows
%     blockRows = blockRows(randperm(height(blockRows)), :);
% 
%     % Separate trial types
%     %targets = blockRows(strcmp(blockRows.category, 'target'), :);
%     %nontargets = blockRows(strcmp(blockRows.category, 'nontarget'), :);
% 
%     % Interleave to avoid consecutive targets/nontargets
%     %interleavedBlock = interleave_trials(targets, nontargets);
% 
%     % Convert to struct and store in finalStruct
%     %blockStruct = table2struct(interleavedBlock);
%     blockStruct = table2struct(blockRows);
%     finalStruct(i) = blockStruct;
%     blockCounter = blockCounter + 1;
%     % for j = 1:length(blockStruct)
%     %     finalStruct(blockCounter) = blockStruct(j);
%     %     blockCounter = blockCounter + 1;
%     % end
% end
% 
% 
% % --- Helper function ---
% function final = interleave_trials(t, nt)
%     final = table();
%     t_idx = 1;
%     nt_idx = 1;
% 
%     % Alternate starting based on longer list
%     if height(t) >= height(nt)
%         pick_target = true;
%     else
%         pick_target = false;
%     end
% 
%     while t_idx <= height(t) || nt_idx <= height(nt)
%         if pick_target && t_idx <= height(t)
%             final = [final; t(t_idx, :)];
%             t_idx = t_idx + 1;
%         elseif ~pick_target && nt_idx <= height(nt)
%             final = [final; nt(nt_idx, :)];
%             nt_idx = nt_idx + 1;
%         end
%         pick_target = ~pick_target; % alternate
%     end
% end

%%
% Randomization of oddball task structure (NEWEST VERSION)

% Convert struct to table for easier processing
T_table = struct2table(T);

% Get unique blocks and shuffle them
blocks = unique(T_table.block_cat_total);
shuffledBlockOrder = blocks(randperm(length(blocks)));

% Final output as struct array
finalStruct = struct();
finalStr = [];
finalIndex = 1;

for i = 1%:length(shuffledBlockOrder)
    block_rows = T_table(T_table.block_cat_total == shuffledBlockOrder(i), :);

    % Randomize the rows in this block
    block_rows = block_rows(randperm(height(block_rows)), :);

    % Attempt to reorder this block with constraints
    reordered_block = reorder_block_with_constraints(block_rows);

    % Convert to struct and store
    block_struct = table2struct(reordered_block);
    block_struct = block_struct.';
    % finalStruct(finalIndex) = block_struct(i);
    % finalIndex = finalIndex + 1;
    finalStruct = [finalStruct, block_struct];
    % finalStr =  [finalStr, block_struct];
    % for j = 1:length(block_struct)
    %     finalStruct(finalIndex) = block_struct(j);
    %     finalIndex = finalIndex + 1;
    % end
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

for itrial = 1:length(T)
    T.(itrial).trial = itrial;

    double_target = 1;
    double_nontarget = 1;
    
    while double_target == 1 | double_nontarget == 1
    
        T = shuffle(T);
    
        category = [T.category];
    
        is_target    = strcmp(category, 'target');
        is_nontarget = strcmp(category, 'nontarget');
    
        double_target    = any(diff(is_target) == 0 & is_target(1:end-1) == 1);
        double_nontarget = any(diff(is_nontarget) == 0 & is_nontarget(1:end-1) == 1);


    end
end
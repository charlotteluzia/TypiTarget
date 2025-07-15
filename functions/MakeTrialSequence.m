function [T_fin] = MakeTrialSequence(P)
%%
% read excel files with image name and category
% in case of indoor scene stimuli (bedroom/living room/kitchen) additional
% ratings of typicality available, typicality ratings serve as criterion of
% selection 
% images for standard categories in ODDBALL TASK
 
stim_140            = readtable(P.stim_140);
match               = wildcardPattern + '/';
stim_140.stimulus   = erase(stim_140.stimulus, match);
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
    cat_idx  = strcmp(stim_140.category, cat_name);
    cat_tab  = stim_140(cat_idx,:);
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

    idx_typ   = find([stim_select(icat).info.p_typicality] > typicality_median(icat)); % >
    idx_untyp = find([stim_select(icat).info.p_typicality] <= typicality_median(icat)); % <=

    for i_cat_block = 1:P.nblocks_per_category

        idx_typ   = randperm(length(idx_typ));
        idx_untyp = randperm(length(idx_untyp));

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

%%
% this version works only with less or equal to 10% targets and 10%
% nontargets
% T_table = struct2table(T);
% 
% % Shuffle block order
% blocks = unique(T_table.block_total);
% shuffledBlocks = blocks(randperm(length(blocks)));
% 
% % Final output
% finalStruct = [];
% finalIndex = 1;
% 
% for i = 1:length(shuffledBlocks)
%     % Extract block
%     block_rows = T_table(T_table.block_total == shuffledBlocks(i), :);
% 
%     % Separate by category
%     is_target = strcmp(block_rows.category, 'target');
%     is_nontarget = strcmp(block_rows.category, 'nontarget');
%     is_other = ~(is_target | is_nontarget);
% 
%     targets = block_rows(is_target, :);
%     nontargets = block_rows(is_nontarget, :);
%     others = block_rows(is_other, :);
% 
%     specials = [targets; nontargets];
%     specials = specials(randperm(height(specials)), :);
%     others = others(randperm(height(others)), :);
% 
%     % Constraint check
%     if height(specials) > height(others) + 1
%         error(['Block "%s" has too many special trials. Required: ≤%d, Found: %d'], ...
%               string(shuffledBlocks(i)), height(others)+1, height(specials));
%     end
% 
%     % Create N+1 gaps
%     num_gaps = height(others) + 1;
%     gaps = cell(num_gaps, 1);
% 
%     % Assign specials to non-adjacent gaps using random spacing of 2 or more
%     special_idx = 1;
%     current_gap = randi([1, 2]);  % Random start at gap 1 or 2
% 
%     while special_idx <= height(specials)
%         if current_gap > num_gaps
%             error('Not enough spacing available to insert specials with desired gaps.');
%         end
%         gaps{current_gap} = specials(special_idx, :);
%         special_idx = special_idx + 1;
% 
%         % Jump forward by random 2–3 gap steps
%         jump = randi([2, 3]);
%         current_gap = current_gap + jump;
%     end
% 
%     % Reconstruct block
%     block = table();
%     for k = 1:height(others)
%         if ~isempty(gaps{k})
%             block = [block; gaps{k}];
%         end
%         block = [block; others(k, :)];
%     end
%     if ~isempty(gaps{end})
%         block = [block; gaps{end}];
%     end
% 
%     % Add to final struct
%     block_struct = table2struct(block);
%     block_struct = block_struct.';
%     finalStruct = [finalStruct, block_struct];
%     % for j = 1:length(block_struct)
%     %     finalStruct(finalIndex) = block_struct(j);
%     %     finalIndex = finalIndex + 1;
%     % end
% end
% 


%%
% this version works with 20% targets and 20% nontargets, and 15% for both
% groups
T_table = struct2table(T);

% Shuffle block order
blocks = unique(T_table.block_total);
shuffledBlocks = blocks(randperm(length(blocks)));

% Final output
finalStruct = [];
finalIndex = 1;

for i = 1:length(shuffledBlocks)
    % Extract block
    block_rows = T_table(T_table.block_total == shuffledBlocks(i), :);

    % Split categories
    is_target = strcmp(block_rows.category, 'target');
    is_nontarget = strcmp(block_rows.category, 'nontarget');
    is_other = ~(is_target | is_nontarget);

    targets = block_rows(is_target, :);
    nontargets = block_rows(is_nontarget, :);
    others = block_rows(is_other, :);

    specials = [targets; nontargets];
    specials = specials(randperm(height(specials)), :);
    others = others(randperm(height(others)), :);

    % Enforced constraint: can only fit specials if #specials ≤ #others + 1
    if height(specials) > height(others) + 1
        error(['Block "%s" has too many special trials for fixed "other" count.\n' ...
               'Specials: %d, Others: %d → Max allowed specials: %d'], ...
               string(shuffledBlocks(i)), height(specials), height(others), height(others)+1);
    end

    % Insert specials between others
    % Create gaps: cell array of n+1 slots
    num_gaps = height(others) + 1;
    gaps = cell(num_gaps, 1);

    % Randomly assign specials to gaps without consecutive assignments
    gap_indices = randperm(num_gaps, height(specials));
    for j = 1:height(specials)
        gaps{gap_indices(j)} = specials(j, :);
    end

    % Reconstruct block
    block = table();
    for k = 1:height(others)
        % Add gap before other (if any)
        if ~isempty(gaps{k})
            block = [block; gaps{k}];
        end
        block = [block; others(k, :)];
    end
    % Add last trailing gap (if any)
    if ~isempty(gaps{end})
        block = [block; gaps{end}];
    end

    % Add to final struct
    block_struct = table2struct(block);
    block_struct = block_struct.';
    finalStruct = [finalStruct, block_struct];
    % for j = 1:length(block_struct)
    %     finalStruct(finalIndex) = block_struct(j);
    %     finalIndex = finalIndex + 1;
    % end
end



%%
% 
% % Convert to table for easier processing
% T_table = struct2table(T);
% 
% % Get unique blocks and shuffle their order
% blocks = unique(T_table.block_total);
% shuffledBlocks = blocks(randperm(length(blocks)));
% 
% % Final output struct array
% finalStruct = [];
% finalIndex = 1;
% 
% % --- Process each block ---
% for i = 1:length(shuffledBlocks)
%     block_rows = T_table(T_table.block_total == shuffledBlocks(i), :);
%     block_rows = block_rows(randperm(height(block_rows)), :);
% 
%     % Split into categories
%     is_target = strcmp(block_rows.category, 'target');
%     is_nontarget = strcmp(block_rows.category, 'nontarget');
%     is_other = ~(is_target | is_nontarget);
% 
%     targets = block_rows(is_target, :);
%     nontargets = block_rows(is_nontarget, :);
%     others = block_rows(is_other, :);
% 
%     % Shuffle each group
%     targets = targets(randperm(height(targets)), :);
%     nontargets = nontargets(randperm(height(nontargets)), :);
%     others = others(randperm(height(others)), :);
% 
%     % Interleave: distribute target/nontargets with 2+ others between
%     interleaved_block = insert_random_spacing(targets, nontargets, others);
% 
%     % Convert to struct and store in finalStruct
%     block_struct = table2struct(interleaved_block);
%     block_struct = block_struct.';
%     finalStruct = [finalStruct, block_struct];
%     % for j = 1:length(block_struct)
%     %     finalStruct(finalIndex) = block_struct(j);
%     %     finalIndex = finalIndex + 1;
%     % end
% end
% 
% 
% % --- Function to insert spaced trials ---
% function final = insert_random_spacing(targets, nontargets, others)
%     specials = [targets; nontargets];
%     specials = specials(randperm(height(specials)), :);
% 
%     final = table();
%     other_idx = 1;
%     special_idx = 1;
% 
%     while special_idx <= height(specials)
%         % Random spacing: insert 1 to 3 others (you can tweak max)
%         spacing = randi([1, 2]);
% 
%         for k = 1:spacing
%             if other_idx <= height(others)
%                 final = [final; others(other_idx, :)];
%                 other_idx = other_idx + 1;
%             end
%         end
%         % Insert one special
%         final = [final; specials(special_idx, :)];
%         special_idx = special_idx + 1;
% 
%     end
% 
%     % If any remaining others
%     while other_idx <= height(others)
%         final = [final; others(other_idx, :)];
%         other_idx = other_idx + 1;
%     end
% end

%%
% Randomization of oddball task structure (NEWEST VERSION)

% Convert struct to table for easier processing
% T_table = struct2table(T);
% 
% % Get unique blocks and shuffle them
% blocks = unique(T_table.block_total);
% shuffledBlockOrder = blocks(randperm(length(blocks)));
% 
% % Final output as struct array
% finalStruct = [];
% finalIndex = 1;
% 
% for i = 1:length(shuffledBlockOrder)
%     block_rows = T_table(T_table.block_total == shuffledBlockOrder(i), :);
% 
%     % Randomize the rows in this block
%     block_rows = block_rows(randperm(height(block_rows)), :);
% 
%     % Attempt to reorder this block with constraints
%     reordered_block = reorder_block_with_constraints(block_rows);
% 
%     % Convert to struct and store
%     block_struct = table2struct(reordered_block);
%     block_struct = block_struct.';
%     finalStruct = [finalStruct, block_struct];
% 
% end
% 
% 
% % --- Function to reorder a block avoiding category adjacency conflicts ---
% function ordered = reorder_block_with_constraints(tbl)
%     max_attempts = 10000000;
%     for attempt = 1:max_attempts
%         shuffled = tbl(randperm(height(tbl)), :);
%         if is_valid_order(shuffled.category)
%             ordered = shuffled;
%             return;
%         end
%     end
%     error('Could not satisfy category ordering constraints after %d attempts', max_attempts);
% end
% 
% % --- Function to check for consecutive category violations ---
% function valid = is_valid_order(category)
%     valid = true;
%     for i = 2:length(category)
%         prev = category{i-1};
%         curr = category{i};
%         if strcmp(prev, 'target') && strcmp(curr, 'target')
%             valid = false; return;
%         elseif strcmp(prev, 'nontarget') && strcmp(curr, 'nontarget')
%             valid = false; return;
%         elseif (strcmp(prev, 'target') && strcmp(curr, 'nontarget')) || ...
%                (strcmp(prev, 'nontarget') && strcmp(curr, 'target'))
%             valid = false; return;
%         end
%     end
% end

%% 
% find all already used images in oddball task in order to include them in
% and to not use them again and select new foils for the memory task
% n_trials = 80 here we get the rest of the untypical images

for icat = 1:length(P.scene_categories)

    % Names of all images.
    all_cat_imgs = {stim_select(icat).info.stimulus};

    idx_cat = strcmp({T.category}, P.scene_categories{icat});
    used_cat_imgs = {T(idx_cat).filename};

    available_imgs = find(~ismember(all_cat_imgs, used_cat_imgs));

    stim_available(icat).info = stim_select(icat).info(available_imgs);
end

%%
% read excel files with image name and category
% in case of indoor scene stimuli (bedroom/living room/kitchen) additional
% ratings of typicality available, typicality ratings serve as criterion of
% selection 
% images for standard categories in MEMORY TASK
% if n_trials >= 80 we need more typical images
 
stim_mem            = readtable(P.stim_mem);

match               = wildcardPattern + '/';
stim_mem.stimulus   = erase(stim_mem.stimulus, match);

% stim_targets_idx    = readtable(P.stim_target);
% stim_nontargets_idx = readtable(P.stim_nontarget);
% stim_targets        = table2struct(stim_targets_idx);
% stim_nontargets     = table2struct(stim_nontargets_idx);
% stim_targets        = struct('info', stim_targets);
% stim_nontargets     = struct('info', stim_nontargets);

%%
% get info for room categories for standard stimuli for memory task
stim_mem_available = struct([]);
for imem = 1:length(P.scene_categories)
    mem_name = P.scene_categories{imem};
    mem_idx  = strcmp(stim_mem.category, mem_name);
    mem_tab  = stim_mem(mem_idx,:);
    mem_struct = table2struct(mem_tab);
    stim_mem_available(imem).info = mem_struct;

    % typicality_median(imem) = median([stim_select(imem).info.p_typicality]);
end

%%
% get new images/foils for the memory task

M = struct();

itrial = 0;
block_mem_total = 1;

for imem = 1:length(P.scene_categories)

    
    idx_typ   = find([stim_mem_available(imem).info.p_typicality] > typicality_median(imem)); %>=
    idx_untyp = find([stim_available(imem).info.p_typicality] <= typicality_median(imem)); %<



    for i_mem_block = 1:P.nblocks_per_category

        % Select typical images.
        [itrial, M, idx_typ, block_mem_total]   = get_images_mem(itrial, M, stim_mem_available(imem), idx_typ, i_mem_block, block_mem_total, P.n_typ);

        % Select untypical images.
        [itrial, M, idx_untyp, block_mem_total] = get_images_mem(itrial, M, stim_available(imem), idx_untyp, i_mem_block, block_mem_total, P.n_untyp);

        block_mem_total = block_mem_total + 1;
       
    end
end

%%
% struct for memory task, including images of oddball task plus new foils
% act on copy of T
T_C = T;
allCatnames = {T_C.category};
% delete all entries with target/nontarget as category, these do not go
% into the memory struct
idxDel = contains(allCatnames, 'target');
T_C(idxDel) = [];
% perform some adjustments to make it suitable for further processing
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
% T_table = struct2table(T);
% 
% % Get unique blocks and shuffle them
% blocks = unique(T_table.block_total);
% shuffledBlockOrder = blocks(randperm(length(blocks)));
% 
% % Final output as struct array
% finalStruct = [];
% finalIndex = 1;
% 
% for i = 1:length(shuffledBlockOrder)
%     block_rows = T_table(T_table.block_total == shuffledBlockOrder(i), :);
% 
%     % Randomize the rows in this block
%     block_rows = block_rows(randperm(height(block_rows)), :);
% 
%     % Attempt to reorder this block with constraints
%     reordered_block = reorder_block_with_constraints(block_rows);
% 
%     % Convert to struct and store
%     block_struct = table2struct(reordered_block);
%     block_struct = block_struct.';
%     finalStruct = [finalStruct, block_struct];
% 
% end
% 
% 
% % --- Function to reorder a block avoiding category adjacency conflicts ---
% function ordered = reorder_block_with_constraints(tbl)
%     max_attempts = 5000000;
%     for attempt = 1:max_attempts
%         shuffled = tbl(randperm(height(tbl)), :);
%         if is_valid_order(shuffled.category)
%             ordered = shuffled;
%             return;
%         end
%     end
%     error('Could not satisfy category ordering constraints after %d attempts', max_attempts);
% end
% 
% % --- Function to check for consecutive category violations ---
% function valid = is_valid_order(category)
%     valid = true;
%     for i = 2:length(category)
%         prev = category{i-1};
%         curr = category{i};
%         if strcmp(prev, 'target') && strcmp(curr, 'target')
%             valid = false; return;
%         elseif strcmp(prev, 'nontarget') && strcmp(curr, 'nontarget')
%             valid = false; return;
%         elseif (strcmp(prev, 'target') && strcmp(curr, 'nontarget')) || ...
%                (strcmp(prev, 'nontarget') && strcmp(curr, 'target'))
%             valid = false; return;
%         end
%     end
% end

%%

% % Combine both structures into one array
% allStructs = [finalStruct, randomizedStruct];
% 
% % Extract all block_total values
% allBlockTotals = [allStructs.block_total];
% 
% % Get unique block_total values in sorted order
% uniqueBlocks = unique(allBlockTotals);
% 
% % Randomize the order of block_total groups
% randOrder = uniqueBlocks(randperm(length(uniqueBlocks)));
% 
% % Initialize combined structure
% T_fin = struct([]);
% 
% % Index for combinedStruct
% idx = 1;
% 
% % Loop through each unique block_total value
% for i = 1:length(randOrder)
%     currentBlock = randOrder(i);
% 
%     % Find matching elements in finalStruct
%     aMatch = finalStruct([finalStruct.block_total] == currentBlock);
% 
%     % Find matching elements in randomizedStruct
%     bMatch = randomizedStruct([randomizedStruct.block_total] == currentBlock);
% 
%     % Combine them
%     group = [aMatch, bMatch];
% 
%     T_fin = [T_fin, group];
% 
%     % Add to combined structure
%     % for j = 1:length(group)
%     %     combinedStruct(idx) = group(j);
%     %     idx = idx + 1;
%     % end
% end

%%
% 
% % Step 1: Get all unique block_total values
% allBlockTotals = [finalStruct.block_total, randomizedStruct.block_total];
% uniqueBlocks = unique(allBlockTotals);
% uniqueBlocks = sort(uniqueBlocks);  % e.g., [1,2,3,4,5,6]
% 
% % Step 2: Initialize combined structure
% combinedStruct = struct([]);
% idx = 1;
% 
% % Step 3: Set chunk size (3)
% chunkSize = 2;
% numBlocks = length(uniqueBlocks);
% 
% % Step 4: Process in position-based chunks of 3
% for k = 1:chunkSize:numBlocks
%     chunkEnd = min(k + chunkSize - 1, numBlocks);
% 
%     % Get current chunk of block_total values
%     currentChunk = uniqueBlocks(k:chunkEnd);
% 
%     % Randomize the chunk
%     randChunk = currentChunk(randperm(length(currentChunk)));
% 
%     % For each block_total in the randomized chunk
%     for i = 1:length(randChunk)
%         currentBlock = randChunk(i);
% 
%         % Get matches from structA and structB
%         aMatch = finalStruct([finalStruct.block_total] == currentBlock);
%         bMatch = randomizedStruct([randomizedStruct.block_total] == currentBlock);
% 
%         % Combine and add to combinedStruct
%         group = [aMatch, bMatch];
%         combinedStruct = [combinedStruct, group];
% 
%         % for j = 1:length(group)
%         %     combinedStruct(idx) = group(j);
%         %     idx = idx + 1;
%         % end
%     end
% end

%%
% two groups if 2 blocks per category, each group with randomized order of
% category kitchen, bedroom and living room, variable block_total stays
% same 
if P.nblocks_per_category == 2
    % Step 1: Define the block groups
    setA = [1, 3, 5];
    setB = [2, 4, 6];

    % Step 2: Shuffle each set independently
    shuffledA = setA(randperm(length(setA)));
    shuffledB = setB(randperm(length(setB)));
    
    % Step 3: Combine both shuffled sets into one final order
    finalOrder = [shuffledA, shuffledB];  % You can also interleave or reverse if needed
    
    % Step 4: Initialize combined structure
    T_fin = struct([]);
    idx = 1;
    
    % Step 5: Go through finalOrder and collect matching elements
    for i = 1:length(finalOrder)
        currentBlock = finalOrder(i);
        
        % Get matches from finalStruct and randomizedStruct
        aMatch = finalStruct([finalStruct.block_total] == currentBlock);
        bMatch = randomizedStruct([randomizedStruct.block_total] == currentBlock);
        
        % Combine and add to final structure
        group = [aMatch, bMatch];
        T_fin = [T_fin, group];
    
        % for j = 1:length(group)
        %     combinedStruct(idx) = group(j);
        %     idx = idx + 1;
        % end
    end

elseif P.nblocks_per_category == 1
    setC = [1, 2, 3];
    shuffledC = setC(randperm(length(setC)));

    T_fin = struct([]);

    for i = 1:length(shuffledC)
        currentBlock = shuffledC(i);
        
        % Get matches from finalStruct and randomizedStruct
        aMatch = finalStruct([finalStruct.block_total] == currentBlock);
        bMatch = randomizedStruct([randomizedStruct.block_total] == currentBlock);
        
        % Combine and add to final structure
        group = [aMatch, bMatch];
        T_fin = [T_fin, group];

    end


end




end

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

%% HIER WIRD JETZT GESHUFFLED
% % BLA
% 
% for itrial = 1:length(T)
%     T.(itrial).trial = itrial;
% 
%     double_target = 1;
%     double_nontarget = 1;
% 
%     while double_target == 1 | double_nontarget == 1
% 
%         T = shuffle(T);
% 
%         category = [T.category];
% 
%         is_target    = strcmp(category, 'target');
%         is_nontarget = strcmp(category, 'nontarget');
% 
%         double_target    = any(diff(is_target) == 0 & is_target(1:end-1) == 1);
%         double_nontarget = any(diff(is_nontarget) == 0 & is_nontarget(1:end-1) == 1);
% 
% 
%     end
% end

%%
% shuffle images within their indoor scene category (bedroom/living room/kitchen)
% get index of each image within category to shuffle within 
% category has to match and block of image was shown in/was "member" of

% for imem = 1%:length(P.scene_categories)
%     for ii = 1:length(P.scene_categories)*P.nblocks_per_category
% 
% 
%     idx_cat_mem = strcmp({TM.category},  P.scene_categories{imem}) & [TM.block_mem_total] == ii;
%     end
% end
% 
% 
% to_shuffle = struct([]);
% for ii = 1:length(P.scene_categories)*P.nblocks_per_category
% 
%     idx_cat_mem = find([TM.block_mem_total] == ii);
% 
% 
% end

%%
% Randomization of memory task structure

% Extract unique groups based on category and block_mem_total
% uniqueGroups = unique([string({TM.category})', [TM.block_mem_total]'], 'rows');
% 
% % Initialize randomized struct
% randomizedStruct = [];
% 
% for i = 1:size(uniqueGroups, 1)
%     % Get current group values
%     currentCategory = uniqueGroups(i, 1);
%     currentBlockMem = str2double(uniqueGroups(i, 2));
% 
%     % Find matching entries
%     matches = arrayfun(@(x) strcmp(string(x.category), currentCategory) && x.block_mem_total == currentBlockMem, TM);
% 
%     % Extract group and randomize
%     group = TM(matches);
%     randIdx = randperm(length(group));
%     randomizedGroup = group(randIdx);
% 
%     % Append to final randomized struct
%     randomizedStruct = [randomizedStruct, randomizedGroup];
% end
% 

%%
% % Randomization of oddball task structure
% 
% % Create keys for grouping based on category and block_mem_total
% catKeys = unique([T.block_cat_total]);
% 
% % Get unique keys and initialize cell array to hold each group
% % [uniqueCatKeys, ~, groupIndices] = unique(catKeys);
% % groupedCatStruct = cell(length(uniqueCatKeys), 1);
% 
% 
% 
% % Group and randomize within each group
% for i = 1%:length(catKeys)
%     % Get entries in the current group
%     % CatgroupMembers = (T.block_cat_total == i);
% 
%     matching = arrayfun(@(x) x.block_cat_total == i, T);
%     CatgroupMembers = T(matching);
%     double_target = 1;
%     double_nontarget = 1;
% 
%     while double_target == 1 | double_nontarget == 1
%         % Randomize order within the group
%         randIdx = randperm(length(CatgroupMembers));
%         %groupedCatStruct{i} = CatgroupMembers(randIdx);
%         randomizedCatGroup = CatgroupMembers(randIdx);
%         %CatgroupMembers = shuffle(CatgroupMembers);
% 
%         % condition of targets not following targets or nontargets and
%         % nontargets not following nontargets or targets
%         % no T-T, T-N, N-N, N-T combinations
%         is_target    = strcmp([randomizedCatGroup.category], 'target');
%         is_nontarget = strcmp([randomizedCatGroup.category], 'nontarget');
% 
%         double_target    = any(diff(is_target) == 0 & is_target(1:end-1) == 1);
%         double_nontarget = any(diff(is_nontarget) == 0 & is_nontarget(1:end-1) == 1);
%     end
% 
% end

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


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


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


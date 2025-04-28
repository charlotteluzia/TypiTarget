
%%
stim_140        = readtable(P.stim_140);

%%
stim_select = struct([]);
for icat = 1:length(P.scene_categories)
    cat_name = P.scene_categories{icat};
    cat_idx = strcmp(stim_140.category, cat_name);
    cat_tab = stim_140(cat_idx,:);
    cat_struct = table2struct(cat_tab);
    stim_select(icat).info = cat_struct;

    typicality_median(icat) = median([stim_select(icat).info.p_typicality]);
end

stim_targets    = stim_140;%readtable(P.stim_target);
stim_nontargets = stim_140;%readtable(P.stim_nontarget);


%%
T = struct();

idx_targets    = find(strcmp([stim_targets.category], 'target'));
idx_nontargets = find(strcmp([stim_nontargets.category], 'nontarget'));

itrial = 0;

for icat = 1:length(P.scene_categories)

    idx_typ   = find([stim_select(icat).info.p_typicality]  > typicality_median(icat));
    idx_untyp = find([stim_select(icat).info.p_typicality] <= typicality_median(icat));

    for i_cat_block = 1:P.nblocks_per_category

        % Select typical images.
        [itrial, T, idx_typ] = get_images(itrial, T, stim_select(icat), idx_typ, i_cat_block, P.n_typ);

        % Select untypical images.
        [itrial, T, idx_untyp] = get_images(itrial, T, stim_select(icat), idx_untyp, i_cat_block, P.n_untyp);

    end

end

%% HIER WIRD JETZT GESHUFFLED
% BLA

for itrial = 1:length(T)
    T.(itrial).trial = itrial;
end

%%

for icat = 1:length(P.scene_categories)

    % Names of all images.
    all_cat_imgs = {stim_select(icat).info.stimulus};

    idx_cat = strcmp({T.category}, P.scene_categories{icat});
    used_cat_imgs = {T(idx_cat).filename};

    available_imgs = find(~ismember(all_cat_imgs, used_cat_imgs));

    stim_available(icat).info = stim_select(icat).info(available_imgs);
end
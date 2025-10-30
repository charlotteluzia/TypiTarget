function  [itrial, T, idx_available, block_cat_total] = get_images(itrial, T, image_table, idx_available, i_cat_block, block_cat_total, n_stim)
% get images for "categorization/oddball" task, draw typical and untypical
% images from different datasets for each block of indoor scene categories (bedroom/living
% room/kitchen) plus target and nontarget images
%% 

for i = 1:n_stim

    itrial = itrial + 1;

    this_img = idx_available(1);

    T(itrial).filename        = image_table.info(this_img).stimulus;
    T(itrial).category        = image_table.info(this_img).category;
    if strcmpi(T(itrial).category, 'target')
        T(itrial).category_idx = 1;
    elseif strcmpi(T(itrial).category, 'nontarget')
        T(itrial).category_idx = 2;
    elseif contains(T(itrial).category, 'bedrooms')
        T(itrial).category_idx = 3;
    elseif contains(T(itrial).category, 'kitchens')
        T(itrial).category_idx = 4;
    elseif contains(T(itrial).category, 'living_rooms')
        T(itrial).category_idx = 5;
    end
    T(itrial).p_typicality    = image_table.info(this_img).p_typicality;
    if T(itrial).p_typicality <= 5
        T(itrial).typicality_idx = 1;
    elseif T(itrial).p_typicality > 5
        T(itrial).typicality_idx = 2;
    end
    T(itrial).n_block         = i_cat_block;
    T(itrial).task            = 'oddball';
    T(itrial).cond            = 'old';
    T(itrial).cond_idx        = 1;
    T(itrial).block_total     = block_cat_total;

    idx_available(1) = [];
end
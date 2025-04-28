function  [itrial, T, idx_available] = get_images(itrial, T, image_table, idx_available, i_cat_block, n_stim)

%%
for i = 1:n_stim

    itrial = itrial + 1;

    this_img = idx_available(1);

    T(itrial).filename     = image_table.info(this_img).stimulus;
    T(itrial).category     = image_table.info(this_img).category;
    T(itrial).p_typicality = image_table.info(this_img).p_typicality;
    T(itrial).cat_block    = i_cat_block;
    T(itrial).task         = 'oddball';

    idx_available(1) = [];
end
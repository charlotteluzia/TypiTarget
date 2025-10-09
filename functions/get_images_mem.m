function  [itrial, M, idx_available, block_mem_total] = get_images_mem(itrial, M, image_table, idx_available, i_mem_block, block_mem_total, n_stim)

%%
for i = 1:n_stim

    itrial = itrial + 1;

    this_img = idx_available(1);

    M(itrial).filename     = image_table.info(this_img).stimulus;
    M(itrial).category     = image_table.info(this_img).category;
    if contains(M(itrial).category, 'target')
        M(itrial).category_idx = 1;
    elseif contains(M(itrial).category, 'nontarget')
        M(itrial).category_idx = 2;
    elseif contains(M(itrial).category, 'bedrooms')
        M(itrial).category_idx = 3;
    elseif contains(M(itrial).category, 'kitchens')
        M(itrial).category_idx = 4;
    elseif contains(M(itrial).category, 'living_rooms')
        M(itrial).category_idx = 5;
    end
    M(itrial).p_typicality = image_table.info(this_img).p_typicality;
    M(itrial).n_block      = i_mem_block;
    M(itrial).task         = 'memory';
    M(itrial).cond         = 'new';
    M(itrial).cond_idx    = 2;
    M(itrial).block_total  = block_mem_total;

    idx_available(1) = [];
end
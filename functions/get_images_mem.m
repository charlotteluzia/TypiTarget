function  [itrial, M, idx_available, block_mem_total] = get_images_mem(itrial, M, image_table, idx_available, i_mem_block, block_mem_total, n_stim)

%%
for i = 1:n_stim

    itrial = itrial + 1;

    this_img = idx_available(1);

    M(itrial).filename     = image_table.info(this_img).stimulus;
    M(itrial).category     = image_table.info(this_img).category;
    M(itrial).p_typicality = image_table.info(this_img).p_typicality;
    M(itrial).n_block      = i_mem_block;
    M(itrial).task         = 'memory';
    M(itrial).cond         = 'new';
    M(itrial).block_total  = block_mem_total;

    idx_available(1) = [];
end
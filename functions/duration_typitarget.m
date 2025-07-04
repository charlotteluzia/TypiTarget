%%
dur_im  =  700;
dur_isi = 1500;

n_typ = 60;
n_untyp = 20;
n_tar = 10;
n_non = 10;

% Encoding blocks.
dur_encode_block = ((n_tar + n_non + n_untyp + n_typ) * (dur_im + dur_isi)) / 60000;

dur_total_enconde = 2 * 3 * dur_encode_block;

% Test blocks.
dur_test = 3000;

dur_test_block = 2 * (n_tar + n_non + n_untyp + n_typ) * dur_test / 60000; % "2 *" steht hier weil es alte + neue stimuli braucht.

dur_total_test = 2 * 3 * dur_test_block;

dur_total_enconde + dur_total_test

%%
% trials per block 30
% 2 blocks per category
n_trials_per_block = 40;
blocks = 2;

prop_typ       = 0.4;  % proportion of typical images
prop_untyp     = 0.2;  % proportion of untypical images
prop_target    = 0.2;  % proportion of target images
prop_nontarget = 0.2;  %

n_typ_total = n_typ*2*blocks;
n_untyp_total = n_untyp*2*blocks;
n_target_total = n_target*trials_per_block*blocks;
n_nontarget_total = n_nontarget*trials_per_block*blocks;


n_typ       = ceil(prop_typ       * n_trials_per_block);
n_untyp     = ceil(prop_untyp     * n_trials_per_block);
n_target    = ceil(prop_target    * n_trials_per_block);
n_nontarget = ceil(prop_nontarget * n_trials_per_block);
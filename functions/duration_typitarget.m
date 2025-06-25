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
function T = ImageTrialSequence(P)

%% -----------------------------------------------------------------------
% define how many trials and how many images of each condition (standard,
% target, non target) need to be included
%  -----------------------------------------------------------------------

% first define Image Sequence for Oddball/Three Stimlulus Task
total_length = P.prop_typ*P.n_trials_odd + P.prop_untyp*P.n_trials_odd + P.prop_target*P.n_trials_odd + P.prop_nontarget*P.n_trials_odd;

% for cat_no = 1:no_cat_block / while no


double_target = 1;
double_nontarget = 1;

while double_target == 1 | double_nontarget == 1

    T = shuffle(T);

    condition = [T.condition];

    is_target    = strcmp(condition, 'target');
    is_nontarget = strcmp(condition, 'nontarget');

    double_target    = any(diff(is_target) == 0 & is_target(1:end-1) == 1);
    double_nontarget = any(diff(is_nontarget) == 0 & is_nontarget(1:end-1) == 1);


end

% second define Image Sequence for Memory Task
T = shuffle(T);
end
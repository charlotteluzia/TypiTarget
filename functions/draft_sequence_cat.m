T

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

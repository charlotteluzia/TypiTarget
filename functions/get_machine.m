function thismachine = get_machine
% Find out name of this computer.

[ret, thismachine] = system('hostname');   
if ret ~= 0,
   if ispc
      thismachine = getenv('COMPUTERNAME');
   else      
      thismachine = getenv('HOSTNAME');      
   end
end
thismachine = strtrim(thismachine);

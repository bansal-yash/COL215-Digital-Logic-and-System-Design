LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY AND_gate IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        c : OUT STD_LOGIC);
END AND_gate;

ARCHITECTURE Behavioral OF AND_gate IS

BEGIN
    c <= a AND b;

END Behavioral;
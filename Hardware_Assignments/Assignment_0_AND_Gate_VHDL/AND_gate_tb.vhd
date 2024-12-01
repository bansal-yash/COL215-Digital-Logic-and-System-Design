LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY AND_gate_tb IS
END AND_gate_tb;
ARCHITECTURE tb OF AND_gate_tb IS

    COMPONENT AND_gate
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL a, b : STD_LOGIC;
    SIGNAL c : STD_LOGIC;

BEGIN
    UUT : AND_gate PORT MAP(a => a, b => b, c => c);
    a <= '0', '1' AFTER 20 ns, '0' AFTER 40 ns, '1' AFTER 60 ns;
    b <= '0', '1' AFTER 40 ns;
END tb;
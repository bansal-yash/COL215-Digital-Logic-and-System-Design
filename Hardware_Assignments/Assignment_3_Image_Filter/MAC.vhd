library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC is
    Port(
    clk : in std_logic;
    k : in integer;
    i : in integer;
    ans : out integer;
    rst : in std_logic
    );
end MAC;

architecture Behavioral of MAC is
    signal internal_ans : integer := 0;
begin
    ans <= internal_ans;
    process(clk, rst)
    begin
        if(rising_edge(clk)) then
            if rst = '1' then
                internal_ans <= 0;
            else
                internal_ans <= internal_ans + k*i;
            end if;
        end if;
    end process;
    
end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC is
    Port(
    clk : in std_logic;
    k : in integer;
    i : in integer;
    ans : out integer;
    rst : in std_logic
    );
end MAC;

architecture Behavioral of MAC is
    signal internal_ans : integer := 0;
begin
    ans <= internal_ans;
    process(clk, rst)
    begin
        if(rising_edge(clk)) then
            if rst = '1' then
                internal_ans <= 0;
            else
                internal_ans <= internal_ans + k*i;
            end if;
        end if;
    end process;
    
end Behavioral;

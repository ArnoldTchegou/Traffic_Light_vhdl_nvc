library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Counter is
    Port (
        Clk      : in  STD_LOGIC;
        Rst      : in  STD_LOGIC;
        Enable   : in  STD_LOGIC;
        CountOut : out INTEGER range 0 to 1000  -- Integer output for counting
    );
end Counter;

architecture Behavioral of Counter is
    signal count : INTEGER := 0;  -- Use integer for counting cycles
begin
    process (Clk, Rst)
    begin
        if Rst = '1' then
            count <= 0;  -- Reset to 0
        elsif rising_edge(Clk) then
            if Enable = '1' then
                count <= count + 1;  -- Increment by 1 clock cycle
            else
            count <= 0;
            end if;
        end if;
    end process;

    CountOut <= count;  -- Output the count value
end Behavioral;

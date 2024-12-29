library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constantes.all;

entity tb_TrafficLight is
end tb_TrafficLight;

architecture behavior of tb_TrafficLight is

    -- Component Declaration for TrafficLight
    component TrafficLight
        Port (
            Clk    : in  STD_LOGIC;
            Rst    : in  STD_LOGIC;
            Red    : out STD_LOGIC;
            Orange : out STD_LOGIC;
            Green  : out STD_LOGIC;
            Count_time : out INTEGER range 0 to 1000;
            enable_seconds : out STD_LOGIC
        );
    end component;

    -- Signals to connect to TrafficLight
    signal Clk    : STD_LOGIC := '0';
    signal Rst    : STD_LOGIC := '0';
    signal Red    : STD_LOGIC;
    signal Orange : STD_LOGIC;
    signal Green  : STD_LOGIC;
    signal Count_time : INTEGER;
    signal enable_seconds : STD_LOGIC ;

begin

    -- Instantiate the TrafficLight
    uut: TrafficLight
        Port map (
            Clk    => Clk,
            Rst    => Rst,
            Red    => Red,
            Orange => Orange,
            Green  => Green,
            Count_time => Count_time,
            enable_seconds => enable_seconds
        );

    -- Clock generation process (10 ns period)
    Clk_process : process
    begin
        Clk <= '0';
        wait for Horloge;
        Clk <= '1';
        wait for Horloge;
    end process;

    -- Stimulus process to apply resets and check outputs
    stimulus: process
    begin
        -- Apply reset and show initial state
        Rst <= '1';  -- Reset the system
        report "Reset activé" severity note;
        wait for Horloge;
        Rst <= '0';


        -- Display initial values
        report "Initial State: Red = " & std_logic'image(Red) &
               ", Orange = " & std_logic'image(Orange) &
               ", Green = " & std_logic'image(Green) &
               ", enable_seconds = " & std_logic'image(enable_seconds) &
               ", Count_time = " & INTEGER'image(Count_time) severity note;

        -- Wait for the green light to be active
        wait for 120000*Horloge;  -- minute après que le feu soit activé
        report "After 1 minutes Red = " & std_logic'image(Red) &
               ", Orange = " & std_logic'image(Orange) &
               ", Green = " & std_logic'image(Green)&
               ", enable_seconds = " & std_logic'image(enable_seconds) &
               ", Count_time = " & INTEGER'image(Count_time) severity note;
        assert (Green = '1') report "Erreur: Feu vert attendu" severity error;

        -- Wait for the orange light to be active
        wait for 240000*Horloge;  -- 3 minutes après que le feu soit activé
        report "After 3 minutes: Red = " & std_logic'image(Red) &
               ", Orange = " & std_logic'image(Orange) &
               ", Green = " & std_logic'image(Green)&
               ", enable_seconds = " & std_logic'image(enable_seconds) &
               ", Count_time = " & INTEGER'image(Count_time) severity note;
        assert (Orange = '1') report "Erreur: Feu orange attendu" severity error;

        -- Wait for the red light to be active
        wait for 240000*Horloge;  -- 5 minutes après que le feu soit activé
        report "After 5 minutes: Red = " & std_logic'image(Red) &
               ", Orange = " & std_logic'image(Orange) &
               ", Green = " & std_logic'image(Green)&
               ", enable_seconds = " & std_logic'image(enable_seconds) &
               ", Count_time = " & INTEGER'image(Count_time) severity note;
        assert (Orange = '1') report "Erreur: Feu rouge attendu" severity error;

        -- End of simulation
        report "Fin de la simulation" severity note;
        wait;
    end process;

end behavior;

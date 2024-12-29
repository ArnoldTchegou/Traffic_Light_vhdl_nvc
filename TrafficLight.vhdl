library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constantes.all;

entity TrafficLight is
    Port (
        Clk    : in  STD_LOGIC;
        Rst    : in  STD_LOGIC;
        Red    : out STD_LOGIC;
        Orange : out STD_LOGIC;
        Green  : out STD_LOGIC;
        Count_time : out INTEGER range 0 to 1000 ;
        enable_seconds : out STD_LOGIC := '0'
    );
end TrafficLight;

architecture Behavioral of TrafficLight is

    -- Component declarations for 1ms, 1s, and Counter (if needed)
    component Tick1ms is
        Port (
            Clk  : in  STD_LOGIC;
            Rst  : in  STD_LOGIC;
            Tick : out STD_LOGIC
        );
    end component;

    component Tick1s is
        Port (
            Clk  : in  STD_LOGIC;
            Rst  : in  STD_LOGIC;
            Tick : out STD_LOGIC
        );
    end component;

    component Counter is
        Port (
            Clk      : in  STD_LOGIC;
            Rst      : in  STD_LOGIC;
            Enable   : in  STD_LOGIC;
            CountOut : out integer range 0 to 300000000  -- Adjusted to be in clock cycles
        );
    end component;

    -- Signals for counters and ticks
    signal Tick1ms_out : STD_LOGIC;
    signal Tick1s_out  : STD_LOGIC;
    signal Counter_ms_out : integer := 0;  -- Using integer for counter
    signal Counter_s_out  : integer := 0;  
    signal Counter_min_out : integer := 0;  
    signal enable_ms : STD_LOGIC := '0';
    signal enable_s : STD_LOGIC := '0';
    signal enable_min : STD_LOGIC := '0';

begin

    -- Process to control the enables based on time counters
    process (Counter_ms_out, Counter_s_out, Counter_min_out)
    begin
        -- Enable for milliseconds (always active with Tick1ms)
        enable_ms <= '1';

        -- Enable for seconds
        if (Counter_ms_out mod 1001 = 0) and (Counter_ms_out > 0) then  -- 1 second
            enable_s <= '1';
        else
            enable_s <= '0';
        end if;

        -- Enable for minutes
        if (Counter_s_out mod 60= 0) and (Counter_s_out > 0) then  -- 1 minute (60 seconds)
            enable_min <= '1';
        else
            enable_min <= '0';
        end if;
    end process;

    -- Counter instantiations
    Inst_Counter_ms: Counter
        Port map (
            Clk      => Clk,
            Rst      => Rst,
            Enable   => enable_ms,
            CountOut => Counter_ms_out
        );

    Inst_Counter_s: Counter
        Port map (
            Clk      => enable_s,
            Rst      => Rst,
            Enable   => enable_s,
            CountOut => Counter_s_out
        );

    Inst_Counter_min: Counter
        Port map (
            Clk      => enable_min,
            Rst      => Rst,
            Enable   => enable_min,
            CountOut => Counter_min_out
        );

    -- State machine to control the traffic lights
    process (Clk, Rst)
        type State_Type is (Red_State, Orange_State, Green_State);
        variable State : State_Type := Red_State;
    begin
        if Rst = '1' then
            State := Red_State;
            Red    <= '1';
            Orange <= '0';
            Green  <= '0';
        elsif rising_edge(Clk) then
            case State is
                when Red_State =>
                    if Counter_s_out = 59 then  -- 1 minute after Red is on Green is ON
                        State := Green_State;
                        Red    <= '0';
                        Green  <= '1';
                        --report "Transition vers Vert";
                    end if;
                when Green_State =>
                    if Counter_s_out = 179 then  -- 3 minute after Red is on for Orange becomes ON
                        State := Orange_State;
                        Green  <= '0';
                        Orange <= '1';
                        --report "Transition vers Orange";
                    end if;
                when Orange_State =>
                    if Counter_s_out = 299 then  -- 5 minutes after Red is on for Orange to stay on
                        State := Red_State;
                        Orange <= '0';
                        Red    <= '1';
                        --report "Transition vers Rouge";
                    end if;
            end case;
        end if;
    end process;
    
    
    Count_time <= Counter_s_out;
    enable_seconds <= enable_s;

end Behavioral;

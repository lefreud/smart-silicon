library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_skip_adder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC);
end carry_skip_adder;

architecture Behavioral of carry_skip_adder is
    
    signal propagate : std_logic;
    signal ripple_carries : std_logic_vector(4 downto 0);
    
    component full_adder is
     Port ( A : in STD_LOGIC;
             B : in STD_LOGIC;
             Cin : in STD_LOGIC;
             S : out STD_LOGIC;
             Cout : out STD_LOGIC);
    end component;
begin
    propagate <= (A(0) xor B(0)) and (A(1) xor B(1)) and (A(2) xor B(2)) and (A(2) xor B(2));
    
    ripple_carries(0) <= Cin;
    Cout <= Cin when propagate = '1' else
            ripple_carries(4);
    
    adders : for i in 0 to 3 generate
        fa : full_adder
            port map (A => A(i), B => B(i), Cin => ripple_carries(i), S => S(i), Cout => ripple_carries(i + 1));
    end generate;
    
end Behavioral;

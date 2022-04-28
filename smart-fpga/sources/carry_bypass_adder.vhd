library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.SmartPackage.ALL;

entity carry_bypass_adder is
    Port ( A : in std_logic_vector(31 downto 0);
           B : in std_logic_vector(31 downto 0);
           S : out std_logic_vector(31 downto 0));
end carry_bypass_adder;

architecture Behavioral of carry_bypass_adder is
    component carry_skip_adder is
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Cin : in STD_LOGIC;
               S : out STD_LOGIC_VECTOR (3 downto 0);
               Cout : out STD_LOGIC);
    end component;
    
    signal carries : std_logic_vector(8 downto 0);    
begin
    carries(0) <= '0';
    csa : for i in 0 to 7 generate        
        csa_0 : carry_skip_adder
            port map (
                A => A(4 * (i + 1) - 1 downto 4 * i),
                B => B(4 * (i + 1) - 1 downto 4 * i),
                Cin => carries(i),
                S => S(4 * (i + 1) - 1 downto 4 * i),
                Cout => carries(i + 1)
            );
    end generate;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for a SPI master (controller)
entity SPI is
	generic(
		peripherals : integer := 1 -- Number of peripheral devices
		dataWidth   : integer := 8 -- Width of messages in bits
	);
	port(
		clk     : in  STD_LOGIC;
		SCLK    : out STD_LOGIC; 										  -- Signal Clock
		COPI    : out STD_LOGIC; 										  -- Controller Out Peripheral In (MOSI)
		CIPO    : in  STD_LOGIC; 										  -- Controller In Peripheral Out (MISO)
		CS      : out STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0); -- Chip Select (Slave Select)
		sevSegD : out STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);			  -- Chooses which digit[s] to write to 
																				  -- Pull value low to write to that digit
																				  
		sevSegS : out STD_LOGIC_VECTOR(8 - 1 DOWNTO 0)			  -- Segments on each individual digit
																				  -- Pull value low to drive Nixie Tube high
	);
end SPI;

architecture Behavioral of SPI is 
	
	-- Clock frequency of the FPGA board
	constant baseClkFreq: natural := 50000000;
	-- Choose the SPI mode of operation (0 - 3)
	constant SPImode: natural := 0; 
	
	
	
	signal pulse : std_LOGIC := '0';
	signal count : integer range 0 to baseClkFreq := 0;
	
begin

	counter : process(clk)
	begin
		if clk'event and clk = '1' then
			if count = 49999999 then
				count <= 0;
				pulse <= not pulse;
			else
				count <= count + 1;
			end if;
		end if;
	
	end process;
	
	led <= pulse;
	
end Behavioral;
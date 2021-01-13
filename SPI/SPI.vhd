----------------------------------------------------------------------------------
-- Engineer: David Asgar-Deen
-- 
-- Create Date: January 11, 2020
-- Design Name: SPI Examples
-- Module Name: SPI_Master
-- Target Devices: Altera Cyclone IV, EP4CE6E22C8N
-- Description: This design implements an SPI master configuration with
-- tunable SCLK frequencies, SPI modes, and chip/slave select devices.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;
USE 	ieee.std_logic_1164.all;
USE     ieee.math_real.all;

-- Entity declaration for a SPI master (controller)
ENTITY SPI IS
	GENERIC(
		peripherals : INTEGER := 1;       -- Number of peripheral devices
		dataWidth   : INTEGER := 8;       -- Width of messages in bits
		baseClkFreq : NATURAL := 50000000 -- Clock frequency of input clk [Hz]
										  -- IF CHANGED, EDIT VALUE BELOW ARCHITECTURE!
	);
	PORT(
		clk     : IN     STD_LOGIC;								    -- System clock
		rst 	: IN     STD_LOGIC := '1';						    -- Active low reset, asynchronous
		maxFreq : IN     NATURAL := baseClkFreq/2;				    -- Max frequency of clock allowed by peripheral [Hz]
		SPImode : IN     STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";		-- SPI mode "CPOL CPHA", defaults to mode 00
		tDelay  : IN     NATURAL := 0;								-- Time delay between chip select and issuing clock cycles [ns]
		chipAdr : IN     NATURAL := 0;								-- Choose which chip/slave to select
		enable  : IN 	 STD_LOGIC;									-- Active high, enables SPI communication/transaction
		
		SCLK    : BUFFER STD_LOGIC; 								-- Signal Clock
		COPI    : OUT    STD_LOGIC; 								-- Controller Out Peripheral In (MOSI)
		CIPO    : IN     STD_LOGIC; 								-- Controller In Peripheral Out (MISO)
		CS      : OUT    STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   -- Chip Select (Slave Select)	
	);
END SPI;

ARCHITECTURE Behavioral OF SPI IS 
	
	CONSTANT baseClkFreq : NATURAL := 50000000; -- Clock frequency of input clk
	CONSTANT clkDiv : INTEGER := INTEGER(FMAX(CEIL(baseClkFreq/(maxFreq*2)),1)); -- Clock divisions for SCLK relative to clk
																				 -- clkDiv = max(baseClkFreq/(2*maxFreq),1)
	
BEGIN
	
	-- Responsible for SCLK transitions
	SigClk : PROCESS(clk)
	BEGIN
		IF (enable = '1') THEN
			IF clk'event AND clk = '1' THEN
				IF count = 49999999 THEN
					count <= 0;
					pulse <= not pulse;
				ELSE
					count <= count + 1;
				END IF;
			END IF;
		END IF;
	
	END PROCESS;
	
	led <= pulse;
	
END Behavioral;
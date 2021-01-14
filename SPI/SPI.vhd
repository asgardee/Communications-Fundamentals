----------------------------------------------------------------------------------------
-- Engineer: David Asgar-Deen, EIT
-- 
-- Create Date: January 11, 2020
-- Design Name: SPI Examples
-- Module Name: SPI_Master
-- Target Devices: Altera Cyclone IV, EP4CE6E22C8N
-- Description: This design implements an SPI master device with configurable SPI modes,
--				serial clock frequencies, SCLK, transmission data widths, dataWidth, and
--				number of peripheral devices, peripherals.
-- 	
-- 				The SPI mode determines the clock polarity (CPOL) and clock phase (CPHA).							
-- 				There are four valid SPI modes outlined in the chart below:
-- 					+----------+------+------+
-- 					| SPI Mode | CPOL | CPHA |
-- 					+----------+------+------+
-- 					|    0     |  0   |  0   |
-- 					|    1     |  0   |  1   |
-- 					|    2     |  1   |  0   |
-- 					|    3     |  1   |  1   |
-- 					+----------+------+------+
--
-- 				The clock divider determines the frequency of the SCLK, derived
--				from the system clock. For a system with a 50MHz system clock 
--				the clkDiv value can be calculated using the equation:
--					MAX(CEIL(baseClkFreq/(desiredFreq*2)),1)
--				A sample chart listing the values of SCLK given clkDiv is listed
--				below for a 50MHz system clock:
--					+---------------------+-------------------+--------+
--					| Desired SCLK [MHz]  | Actual SCLK [MHz] | clkDiv |
--					+---------------------+-------------------+--------+
--					|     SCLK >=  25     |     SCLK = 25     |   1    |
--					|  12.5 <= SCLK < 25  |    SCLK = 12.5    |   2    |
--					| 8.3 <= SCLK < 12.5  |    SCLK = 8.3     |   3    |
--					| 6.25 <= SCLK <  8.3 |    SCLK = 6.25    |   4    |
--					|  5 <= SCLK < 6.25   |     SCLK = 5      |   5    |
--					+---------------------+-------------------+--------+
--
-- Current Revision: 0.01
--
-- Revision History 0.01 - File Created
--					1.00 - 
-- 
----------------------------------------------------------------------------------------

LIBRARY ieee;
USE 	ieee.std_logic_1164.all;
USE     ieee.math_real.all;

-- Entity declaration for a SPI master (controller)
ENTITY SPI IS
	GENERIC(
		peripherals : INTEGER := 1; -- Number of peripheral devices
		dataWidth   : INTEGER := 8; -- Width of messages in bits
		SPImode		: NATURAL := 0; -- Determines SPI mode, see chart in description
		clkDiv 		: NATURAL := 1; -- Determines SCLK, see chart in description
	);                              
	PORT(
		-- Necessary I/O's
		clk     : IN     STD_LOGIC;								    -- System clock
		enable  : IN 	 STD_LOGIC;									-- Active high, enables SPI communication/transaction
		txData  : IN     STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);  -- Data to transmit to peripheral device
		rxData  : OUT    STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);  -- Data received from peripheral device
		busy    : OUT 	 STD_LOGIC;									-- Informs main logic when SPI system is busy
		SCLK    : BUFFER STD_LOGIC; 								-- Signal Clock
		COPI    : OUT    STD_LOGIC; 								-- Controller Out Peripheral In (MOSI)
		CIPO    : IN     STD_LOGIC; 								-- Controller In Peripheral Out (MISO)
		CS      : OUT    STD_LOGIC_VECTOR(peripherals - 1 DOWNTO 0);-- Chip Select (Slave Select)	
		
		-- Optional I/O's
		rst 	: IN     STD_LOGIC := '1';						    -- Active low reset, asynchronous
		chipAdr : IN     NATURAL := 0;								-- Choose which chip/slave to select
		CPOL    : IN     STD_LOGIC := '0';							-- CPOL = Clock idles CPOL, each clock pulse is NOT(CPOL)
		CPHA    : IN     STD_LOGIC := '0';							-- CPHA = 0; Data sampled on rising edge, shifted out on falling
		tDelay  : IN     NATURAL := 0								-- Time delay between chip select and issuing clock cycles [ns]
	);
END SPI;

ARCHITECTURE Behavioral OF SPI IS 
	
	SIGNAL init : STD_LOGIC := '1';
	SIGNAL count: NATURAL := 0;
	
BEGIN
	
	-- Using one process to ensure no race conditions for signal updates
	SPIproc : PROCESS(clk, rst)
	BEGIN
		-- Check if reset has been enabled
		IF (rst = '0' OR init = '1') THEN
			busy <= '1'; 			-- Assert the system as busy
			init <= '0'; 			-- Turn off initialization
			CS <= (OTHERS => '1'); 	-- De-assert all peripheral lines
			SCLK <= CPOL;			-- Reset SCLK to idle
			rxData <= (OTHERS => '0'); -- Clear received data buffer
		END IF;
	END PROCESS;
	
	
END Behavioral;
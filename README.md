# Semiconductor Optics Simulations
bunch of scripts for simulating various semiconductor optics devices; written in VBA and MATLAB

### MATLAB - AlxGa1−xAs Quantum Well Simulation (`MATLAB_AlGaAs.m`)
script is for designing a quantum well inside VCSEL to emit light at a specific wavelength (i.e 850 nm) using modified aluminium gallium arsenide (AlGaAs) materials. The script calculates the necessary material compositions, potential, and effective electron mass for different concentrations of Aluminium in AlGaAs. It also includes for visualizions for the potential, effective mass, and transmission coefficients, as well as calculating and plotting wave functions.

### VBA - VCSEL at 840 nm (`VBA_VCSEL_at_840nm.vba`)
script to calculate key parameters of a VCSEL designed to emit light at 840 nm; it determines the thickness of layers, reflectivities of the upper and lower DBRs (Distributed Bragg Reflectors), the center wavelength of the photonic bandgap, refractive index contrast, and the bandwidth of the photonic bandgap based on user inputs. The results are displayed on an user interface.

### VBA - Photonic Crystals (`VBA_Photonic_Crystals.vba`)
script generates an input file for a MATLAB program, for more granular analysis of photonic crystals. It retrieves data from the Excel worksheet, including the number of pairs in the Bragg reflectors and their refractive indices and layer thicknesses, and then formats this information into a data file suitable for MATLAB.

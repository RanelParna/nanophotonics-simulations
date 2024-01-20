# Semiconductor Optics Simulations

This repository contains a collection of scripts used for simulating and analyzing various semiconductor optics devices. The scripts are written in VBA and MATLAB and are focussed on quantum wells and VCSELs (Vertical-Cavity Surface-Emitting Lasers).

## Contents

### MATLAB - AlxGa1−xAs Quantum Well Simulation (`MATLAB_AlGaAs.m`)

This MATLAB script is designed for designing a quantum well structure to emit light at a specific wavelength (850 nm) using an aluminium gallium arsenide (AlGaAs) material system. The script calculates the necessary material composition, potential, and effective electron mass for different concentrations of Aluminium in AlGaAs. It also includes functionality for visualizing the potential, effective mass, and transmission coefficients, as well as calculating and plotting wave functions.

### VBA - VCSEL at 840 nm (`VBA_VCSEL_at_840nm.vba`)

A VBA script tailored for Microsoft Excel, used to calculate key parameters of a VCSEL designed to emit light at 840 nm. The script determines the thickness of layers, reflectivities of the upper and lower DBRs (Distributed Bragg Reflectors), the center wavelength of the photonic bandgap, refractive index contrast, and the bandwidth of the photonic bandgap based on user inputs. The results are displayed in the Excel sheet for easy interpretation and analysis.

### VBA - Photonic Crystals (`VBA_Photonic_Crystals.vba`)

This VBA script generates an input file for a MATLAB program, which is used for the analysis of photonic crystals. It retrieves data from an Excel worksheet, including the number of pairs in the Bragg reflectors and their refractive indices and layer thicknesses, and then formats this information into a data file suitable for MATLAB processing.

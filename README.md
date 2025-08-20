# Digital Communication Systems Simulation

📡 MATLAB/Octave implementations of fundamental communication systems for **ECEN314-ECE233: Fundamentals of Communications** course project.

## 📂 Project Overview
This repository contains simulations and reports for two main parts of the project:

### Part 1: SSB & QAM Systems
- **Single Sideband (SSB) Modulation/Demodulation**
  - Implemented using Hilbert Transform for USB & LSB.
  - Two independent message signals were modulated: one into USB and one into LSB.
  - Successful recovery of both signals after coherent demodulation.
- **Quadrature Amplitude Modulation (QAM)**
  - One signal transmitted on the in-phase (I) channel, another on the quadrature (Q) channel.
  - Accurate recovery at the receiver using correlation with orthogonal carriers.
- **Impairments**
  - Simulated **phase offset** and **frequency offset** between transmitter & receiver.
  - Observed distortion in demodulated signals and constellation rotation.

📄 Detailed results and plots are available in `Communication project.pdf`.


### Part 2: FM Stereo Transmitter
Based on the provided block diagram of the FM stereo system:

1. Record two audio files (Left: `L.wav`, Right: `R.wav`).
2. Generate:
   - **Sum signal**: `l(t) + r(t)`
   - **Difference signal**: `l(t) - r(t)`
3. Modulate the difference signal using DSB with a **38 kHz subcarrier** (generated via 19 kHz pilot tone + frequency doubler).
4. Form the composite baseband signal:
   \[
   X_b(t) = [l(t)+r(t)] + [(l(t)-r(t)) \cdot \cos(2\pi \cdot 38k t)] + \text{pilot tone at 19 kHz}
   \]
5. Input `X_b(t)` into an FM modulator with the group’s assigned carrier frequency.
6. Plot signals at **points A, B, C, D, and E** in both **time domain** and **frequency domain**.

📄 Final report with results and plots (to be added once Part 2 is completed).


## 🛠️ Tools
- MATLAB / Octave (no built-in comm toolbox functions used).
- Custom Hilbert transform function (`hilbm.m`).
- Scripts for modulation, demodulation, and plotting.

---

## 📑 Deliverables
- Source code (`.m` files).
- Reports (`.pdf`).
- Figures and plots for analysis.

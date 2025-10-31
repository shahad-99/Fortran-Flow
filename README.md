<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/b/b8/Fortran_logo.svg" alt="Fortran Logo" width="150"/>
  <h1>PowerShell Fortran Runner for VS Code</h1>
  <p>A powerful script to compile and run Fortran code on Windows with a single command, directly from the VS Code terminal.</p>

  <p>
    <img src="https://img.shields.io/badge/Language-Fortran-734F96?style=for-the-badge&logo=fortran&logoColor=white" alt="Language Fortran">
    <img src="https://img.shields.io/badge/Language-PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="Language PowerShell">
    <img src="https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Platform Windows">
    <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License MIT">
  </p>
</div>

---

This script (`Run-Fortran.ps1`) automates the entire compile-and-run cycle into a single, easy-to-remember command. It automatically detects the active file in your VS Code editor, compiles it with `gfortran`, and immediately runs the resulting executable.

## Features

-   ✅ **One-Command Execution**: Compile and run your active Fortran file with a single command.
-   🔎 **Auto-Detection**: Automatically finds the name of the file you are currently editing in VS Code.
-   🚀 **Self-Installing Alias**: The first time you run the script, it automatically creates a permanent alias `frun` for you. No manual profile editing required!
-   ⚠️ **Error Checking**: Checks if compilation was successful before attempting to run the program.
-   💬 **User-Friendly Feedback**: Provides clear status messages and error reports directly in the terminal.

## Prerequisites

Before you begin, you need to have the following software installed and configured on your Windows machine.

### 1. Visual Studio Code
The script is designed to integrate with VS Code. You can download it from the official website:
-   ➡️ [**Download Visual Studio Code**](https://code.visualstudio.com/)

### 2. A Fortran Compiler (gfortran)
You need the `gfortran` compiler to be accessible from PowerShell. For most users, **Option 1 is the fastest and easiest way to get started.**

#### Option 1: Quick Setup via Equation.com (Recommended)
This method uses a simple installer that bundles the `gfortran` compiler and automatically adds it to your system's PATH. No manual configuration is needed.

1.  **Download**: Go to the Equation.com Fortran page:
    -   ➡️ [**Download TDM-GCC MinGW Compiler**](https://www.equation.com/servlet/equation.cmd?fa=fortran)
2.  **Install**: Run the downloaded `.exe` installer and follow the on-screen instructions. The default settings are fine.
3.  **Verify**: To confirm the installation was successful, **open a new PowerShell terminal** and type the following command:
    ```powershell
    gfortran --version
    ```
    You should see the compiler's version information. If you get an error, try restarting your computer to ensure the environment variables are updated.

#### Option 2: Full Environment via MSYS2 (Advanced)
This method is for users who may want a more complete development environment with other tools. It requires manually adding the compiler to the Windows PATH.

1.  **Download**: Go to the [**MSYS2 website**](https://www.msys2.org/) and follow their installation instructions.
2.  **Install gfortran**: Once MSYS2 is installed, open the MSYS2 terminal and run:
    ```bash
    pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
    ```
3.  **Add to Windows PATH**: Manually add the compiler's `bin` folder (e.g., `C:\msys64\ucrt64\bin`) to your Windows PATH environment variable.
4.  **Verify**: Open a **new** PowerShell terminal and check the version with `gfortran --version`.

### 3. VS Code Fortran Extension (Recommended)
While not required for the script to work, a good Fortran extension provides syntax highlighting and other essential features.
-   ➡️ [**Modern Fortran**](https://marketplace.visualstudio.com/items?itemName=fortran-lang.linter-gfortran) - A popular and well-maintained choice.

## Installation & Setup

Follow these steps to get the `Run-Fortran.ps1` script set up.

### Step 1: Download the Script
Download the `Run-Fortran.ps1` file from this repository and save it to a permanent location on your computer. A good place for scripts is `C:\Users\YourUser\Documents\PowerShell\Scripts`.

### Step 2: Unblock the Script
Windows security may block scripts downloaded from the internet. To unblock it:
1.  Right-click the `Run-Fortran.ps1` file and select "Properties".
2.  On the "General" tab, check the "**Unblock**" box at the bottom and click "OK".

Alternatively, you can run this command in PowerShell:
```powershell
Unblock-File -Path "C:\Path\To\Your\Script\Run-Fortran.ps1"
```

### Step 3: Run the Script to Create the Alias
This is the magic step. The script will set up its own permanent alias (`frun`) for you.

1.  Open PowerShell.
2.  Navigate to the directory where you saved the script.
3.  Run the script directly:
    ```powershell
    .\Run-Fortran.ps1
    ```
You will see a "First-time setup" message confirming that the alias has been added to your PowerShell profile. This will only happen once.

### Step 4: Reload Your PowerShell Profile
For the new `frun` alias to be available, you must reload your PowerShell profile.
-   **Easiest way**: Close and reopen your VS Code terminal or PowerShell window.
-   **Alternatively**: Run `. $PROFILE` in your current terminal session.

## How to Use

Your development workflow will now be incredibly simple.

1.  Open your Fortran project folder in VS Code.
2.  Open any Fortran file (e.g., `my_program.f90`) and start coding.
3.  When you're ready to test, open the integrated terminal in VS Code (**Ctrl** + **`**).
4.  Make sure the terminal's current directory is the same as your source file's location.
5.  Type the magic command and press Enter:
    ```powershell
    frun
    ```
The script will compile `my_program.f90`, create `my_program.exe`, and run it for you, all in one go.

<!-- ![Demonstration GIF](https://i.imgur.com/your-demo.gif)
*(You can replace the URL above with a link to a GIF demonstrating the workflow)* -->

## Troubleshooting

#### Problem: `gfortran : The term 'gfortran' is not recognized...`
-   **Cause**: The compiler is not in your Windows PATH, or you haven't restarted your terminal since it was added.
-   **Solution**: If you used the **Equation.com installer (Option 1)**, try restarting your computer. If you used **MSYS2 (Option 2)**, double-check that you added the correct directory to your Windows PATH. In either case, ensure `gfortran --version` works in a new terminal.

#### Problem: `...cannot be loaded because running scripts is disabled on this system.`
-   **Cause**: Your PowerShell Execution Policy is too restrictive.
-   **Solution**: Open PowerShell **as an Administrator** and run the following command:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```
    Answer `Y` (Yes) when prompted.

#### Problem: `File 'your_file.f90' not found in the current directory.`
-   **Cause**: Your PowerShell terminal is in a different directory than your source file.
-   **Solution**: Use the `cd` command in the terminal to navigate to the folder containing your Fortran file before running `frun`.

## Contributing
Contributions are welcome! If you have ideas for improvements or find a bug, please open an issue or submit a pull request.

## License
This project is licensed under the [MIT License](LICENSE).
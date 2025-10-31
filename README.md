<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/b/b8/Fortran_logo.svg" alt="Fortran Logo" width="150"/>
  <h1>PowerShell Fortran Runner for VS Code</h1>
  <p>A powerful set of scripts to compile and run Fortran code on Windows with a single command, directly from the VS Code terminal.</p>

  <p>
    <img src="https://img.shields.io/badge/Language-Fortran-734F96?style=for-the-badge&logo=fortran&logoColor=white" alt="Language Fortran">
    <img src="https://img.shields.io/badge/Language-PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="Language PowerShell">
    <img src="https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white" alt="Platform Windows">
    <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License MIT">
  </p>
</div>

---

This project automates the entire Fortran compile-and-run cycle into a single, easy-to-remember command (`frun`). It automatically detects the active file in your VS Code editor, compiles it with `gfortran`, and immediately runs the resulting executable, regardless of your terminal's current location.

## Features

-   ✅ **One-Command Execution**: Compile and run your active Fortran file with the single command `frun`.
-   🔎 **Auto-Detection**: Automatically finds the `.f90`, `.f95`, etc. file you are currently editing in VS Code.
-   📂 **Works From Anywhere**: The script automatically changes to your file's directory to compile and run, so you don't have to.
-   🚀 **Dedicated Installer**: A one-time installer script (`Install-FortranAlias.ps1`) creates a permanent, location-aware alias. No manual profile editing required!
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

This setup uses two scripts: one to install the alias (`Install-FortranAlias.ps1`) and one to perform the compilation (`Invoke-FortranRun.ps1`).

### Step 1: Download the Scripts
Download both `Install-FortranAlias.ps1` and `Invoke-FortranRun.ps1` and save them **in the same folder**. This folder should be a permanent location on your computer. A good place is `C:\Users\YourUser\Scripts`.

### Step 2: Unblock the Scripts
Windows security may block scripts downloaded from the internet. To unblock them:
1.  Right-click on each script file and select "Properties".
2.  On the "General" tab, check the "**Unblock**" box at the bottom and click "OK".

Alternatively, you can run this command in PowerShell for each file:
```powershell
Unblock-File -Path "C:\Path\To\Your\Scripts\Install-FortranAlias.ps1"
Unblock-File -Path "C:\Path\To\Your\Scripts\Invoke-FortranRun.ps1"
```

### Step 3: Run the Installer Script
This is the magic step. The installer script will set up its own permanent alias (`frun`) for you.

1.  Open PowerShell.
2.  Navigate to the directory where you saved the scripts.
3.  Run the **installer** script:
    ```powershell
    .\Install-FortranAlias.ps1
    ```
You will see a confirmation message that the alias has been added to your PowerShell profile. This script automatically detects the correct path, so you never have to edit it manually.

### Step 4: Reload Your PowerShell Profile
For the new `frun` alias to be available, you must reload your PowerShell profile.
-   **Easiest way**: Close and reopen your VS Code terminal or PowerShell window.
-   **Alternatively**: Run `. $PROFILE` in your current terminal session.

## How to Use

Your development workflow will now be incredibly simple.

1.  Open your Fortran project folder in VS Code.
2.  Open any Fortran file (e.g., `my_program.f95`) and make sure it is your **active, focused tab**.
3.  When you're ready to test, open the integrated terminal in VS Code (**Ctrl** + **`**).
4.  Type the magic command and press Enter:
    ```powershell
    frun
    ```
The script will find your active file, switch to its directory, compile it into an `.exe`, and run it for you, all in one go.

## Troubleshooting

#### Problem: `frun : The term 'frun' is not recognized...`
-   **Cause**: You haven't restarted your PowerShell terminal after running the installer script.
-   **Solution**: Close and reopen your terminal. If it persists, run the `Install-FortranAlias.ps1` script again and check for any error messages.

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

#### Problem: `ERROR: No active Fortran file... found in VS Code.`
-   **Cause**: The script could not determine which file you are working on.
-   **Solution**: Make sure the Fortran file you want to compile is the **currently active and focused tab** in your VS Code window. The script reads the window title to find the file name.

## Contributing
Contributions are welcome! If you have ideas for improvements or find a bug, please open an issue or submit a pull request.

## License
This project is licensed under the [MIT License](LICENSE).
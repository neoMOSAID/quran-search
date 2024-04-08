# Command-Line Quran Search and Display Script

Enhance your Quranic study experience with this versatile command-line script for searching and displaying Quranic verses seamlessly. This script allows users to access specific verses, conduct interactive searches, and integrate color-coded output for improved readability.

## Features

- **Interactive Search:** Initiate an interactive search prompt to search for specific keywords or phrases within the Quranic text.
- **Verse Display:** Provide chapter and verse numbers as command-line arguments to display specific verses from the Quran.
- **Visual Enhancement:** Color-coded output for improved readability during verse display.
- **Integration with Text Editor:** Seamlessly open the Uthmani version of the Quran in the 'gedit' text editor directly from the command line.

## Usage

1. Clone the repository to your local machine.
2. Ensure you have the required dependencies installed (e.g., `sed`, `awk`, `paste`, `zenity`, etc.).
3. Navigate to the directory containing the script.
4. Use the script with appropriate command-line arguments as follows:

```bash
./quran_search.sh [chapter] [verse_start] [verse_end]
```

For example, to display verses from chapter 2, verses 1 to 5:
```bash
./quran_search.sh 2 1 5
```

To open the Uthmani version of the Quran in 'gedit':
```bash
./quran_search.sh g
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.




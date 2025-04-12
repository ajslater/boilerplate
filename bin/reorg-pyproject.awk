#!/usr/bin/env awk -f
# Move [project] and everything after to top of pyproject.toml
# Find the line containing "[project]"
/\[project\]/ {
    found = 1;
    project_line = $0;  # Store the project line
    next;             # Skip processing this line further in this cycle
}

# If the found flag is set (i.e., we are processing lines *after* "[project]")
found {
    after[++after_idx] = $0; # Store the line in the "after" array
    next;                    # Skip processing this line further in this cycle
}

# If the found flag is not set (i.e., we are processing lines *before* "[project]")
{
    before[++before_idx] = $0; # Store the line in the "before" array
}

# After processing all lines, print them in the desired order
END {
    if (found) {
      # 1. Print the "[project]" line itself
      print project_line;

      # 2. Print the lines that originally came *after* "[project]"
      for (i = 1; i <= after_idx; i++) {
        print after[i];
      }

      # 3. Print the lines that originally came *before* "[project]"
      for (i = 1; i <= before_idx; i++) {
        print before[i];
      }
    } else {
      # Handle the case where the "[project]" tag is not found.
      print "Error: '\''[project]'\'' not found in the file." > "/dev/stderr"
      exit 1 # Exit with an error code
    }
}

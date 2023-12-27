import os
import re

# Define the directory path of the project here
# For this example, I'm just using a placeholder path
# You would replace this with the path to your project directory
project_directory = './technic'

# Regex to find all lines with either _ingredient or _sounds variables
variable_regex = re.compile(r'(\w+)(_ingredient|_sounds) = (.*)')

# Function to refactor a single file
def refactor_file(file_path):
    changes_made = False
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        for line in lines:
            match = variable_regex.search(line)
            if match:
                variable_name = match.group(1) + match.group(2)
                new_line = f'technic.compat.{variable_name} = {match.group(3)}\n'
                file.write(new_line)
                changes_made = True
            else:
                file.write(line)
    return changes_made

# Function to walk through the project directory and refactor all files
def refactor_project(directory):
    for subdir, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(subdir, file)
            if file_path.endswith('.lua'):
                if refactor_file(file_path):
                    print(f'Refactored {file_path}')

# Run the refactoring on the project directory
refactor_project(project_directory)

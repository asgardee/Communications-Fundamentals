from tabulate import tabulate
import pandas as pd
import os 
import sys

filename = 'SPImodes'
dir_path = os.path.dirname(os.path.realpath(__file__))
fullFile = os.path.join(dir_path, filename + '.csv')
df = pd.read_csv (fullFile)
table = [df.columns.values.tolist()] + df.values.tolist()
# print(tabulate(table, headers = "firstrow", tablefmt='pretty'))
original_stdout = sys.stdout # Save a reference to the original standard output

with open(filename + '.txt', 'w') as f:
    sys.stdout = f # Change the standard output to the file we created.
    print(tabulate(table, headers = "firstrow", tablefmt='pretty'))
    sys.stdout = original_stdout # Reset the standard output to its original value

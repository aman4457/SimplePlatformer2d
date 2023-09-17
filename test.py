text = open("README.md").read().lower()
if len(text) < 2500:
    print("Description is not long enough.")
print(len(text))
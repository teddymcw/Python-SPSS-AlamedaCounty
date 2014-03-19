import sys

SendEmailFrom=sys.argv[1]
SendEmailTo=sys.argv[2:]

print SendEmailTo
print SendEmailFrom
recipient=', '.join(SendEmailTo)
print recipient

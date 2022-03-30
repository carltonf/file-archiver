A simple script for backing files up in a Public Cloud.

These are secondary backup, i.e. files uploaded are also stored in another
storage far easier to retrieve.

# Goals

Files uploaded to the cloud should be

- appropriately encrypted including filenames
- spliced into 100MB volumes for easier transfer with clouds.
- conveniently indexed

# Implementation

The script uses 7z to create volume-based split archives with built-in AES
encryption including header.

Each file or subdirectory under a `Source` directory is grouped into a separate
archive, to be saved to `Destination` directory.

The archive name is the md5sum hash of the full filename (only the basename,
including extension).

A list of "md5sum hash - filename" is generated for indexing purpose, stored in
plain text.


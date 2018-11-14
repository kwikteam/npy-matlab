"""Roundtrip testing of npy-matlab.

Write data in NPY format to be read and rewritten using npy-matlab. Then
re-read the matlab written data again and check if it is still the same.

"""
import os
import os.path as op
from subprocess import call

import numpy as np
import skimage.data

# For numpy data types see:
# https://docs.scipy.org/doc/numpy-1.15.0/user/basics.types.html
SUPPORTED_DTYPES = ['uint8', 'uint16', 'uint32', 'uint64', 'int8', 'int16',
                    'int32', 'int64', 'float32', 'float64']

# Directory of this file
test_dir = op.dirname(op.realpath(__file__))


def _save_testing_data():
    """Write testing data to /tests/data.

    Returns
    -------
    all_saved_data : list of tuples
        all_saved_data[i][0] is the path to written data
        all_saved_data[i][1] is actual data

    """
    # Make a data directory
    data_dir = op.join(test_dir, 'data')
    if not op.exists(data_dir):
        op.mkdir(data_dir)

    # Test 1D data
    n = 10000
    t = np.linspace(-10., 10., n)
    sine = (1 + np.sin(t)) * 64

    # Test 3D data
    chelsea = skimage.data.chelsea()

    # Save all test data in NPY format
    all_saved_data = list()
    for dtype in SUPPORTED_DTYPES:
        sine_tr = sine.astype(dtype)
        fpath = op.join(data_dir, 'sine_{}.npy'.format(dtype))
        np.save(fpath, sine_tr)
        all_saved_data.append((fpath, sine_tr))

        chelsea_tr = chelsea.astype(dtype)
        fpath = op.join(data_dir, 'chelsea_{}.npy'.format(dtype))
        np.save(fpath, chelsea_tr)
        all_saved_data.append((fpath, chelsea_tr))

    return all_saved_data


def test_roundtrip():
    """Test roundtrip."""
    # Write testing data from Python
    all_saved_data = _save_testing_data()

    # General command structure for calling octave
    # note, there is no closing `"` sign. Must be added later.
    main_dir = os.sep.join(test_dir.split(os.sep)[:-1])
    func_dir = op.join(main_dir, 'npy-matlab')
    cmd_octave = 'octave --no-gui --eval "'
    cmd_octave += "addpath('{}');".format(func_dir)

    # Now for each data type and testing data:
    # read with octave
    # re-write with octave
    # re-read with numpy and assert it is the same
    for i in range(len(all_saved_data)):
        # Get the original data
        fpath = all_saved_data[i][0]
        original_data = all_saved_data[i][1]

        # Read into octave and write back from octave
        new_fpath = op.join(op.split(fpath)[0], 'matlab_' + op.split(fpath)[1])
        cmd_read = "new_data=readNPY('{}');".format(fpath)
        cmd_write = "writeNPY(new_data, '{}');".format(new_fpath)
        cmd_complete = cmd_octave + cmd_read + cmd_write + '"'
        print(cmd_complete)
        call(cmd_complete, shell=True)

        # Read back with numpy and assert it's the same
        new_data = np.load(new_fpath)
        np.testing.assert_array_equal(original_data, new_data.squeeze())

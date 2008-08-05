# -*- coding=utf-8 -*-

def sort_by_attr(seq, attr):
    """Sort the sequence of objects by object's attribute

    Arguments:
    seq  - the list or any sequence (including immutable one) of objects to sort.
    attr - the name of attribute to sort by

    Returns:
    the sorted list of objects.
    """

    # Use the "Schwartzian transform"
    # Create the auxiliary list of tuples where every i-th tuple has form
    # (seq[i].attr, i, seq[i]) and sort it. The second item of tuple is needed not
    # only to provide stable sorting, but mainly to eliminate comparison of objects
    # (which can be expensive or prohibited) in case of equal attribute values.
    intermed = [ (getattr(seq[i],attr), i, seq[i]) for i in xrange(len(seq)) ]
    intermed.sort()
    return [ tup[-1] for tup in intermed ]


def sort_by_attr_inplace(lst, attr):
    """Inplace sort the list of objects by object's attribute
    """
    lst[:] = sort_by_attr(lst, attr)

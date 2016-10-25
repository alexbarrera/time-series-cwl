import json
import textwrap
import argparse
import os


def save_or_print_json(json_str, outdir, json_name):
    if outdir:
        with open("%s/%s.json" % (outdir, json_name), 'w') as cout:
            cout.writelines(json_str)
    else:
        print "#%s.json" % json_name
        print json_str


def create_json(bigwigs_list=None, args=None):
    ret = {
        'nthreads': args.nthreads,
        'nextend_bins_tuples': args.nextend_bins_tuples,
        'regions_bedfile': {'class': 'File', 'path': os.path.abspath(args.regions_bedfile.name)},
        'bigwigs': [[{'class': 'File', 'path': p} for p in bw] for bw in
                    bigwigs_list]
    }

    return json.dumps(ret, indent=4)


def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent('''
            Parse metadata and create workflow JSONs using templates
            --------------------------------------------------------
            '''))

    parser.add_argument('-regions-bedfile', type=file, required=True,
                        help='Bedfile with the regions used as anchor points.')
    parser.add_argument('-gtf', type=file, required=True,
                        help='GTF annotation file used to retrieve genes names')
    parser.add_argument('--nthreads', type=int, dest='nthreads', default=1,
                        help='Number of threads.')
    parser.add_argument('--nextend-bins-tuples', type=int,
                        action='append', nargs='+', required=True,
                        help='Pairs of (1) Number of bases to extend to '
                             'each side of the anchor point, and (2) number of '
                             'bins (can be specified multiple times)')

    # Mutually exclusive options
    group = parser.add_mutually_exclusive_group(required=True)

    group.add_argument('--factor-bigwigs', type=file, nargs='+',
                       action='append', help='Bigwigs for a factor (can be '
                                             'specified multiple times)')

    group.add_argument('--factor-bigwigs-list-file', type=file, nargs='+',
                       help='File containing paths for bigwig files (can be '
                            'specified multiple times)')

    # Parse input
    args = parser.parse_args()

    bws = []
    if args.factor_bigwigs:
        bws = [[os.path.abspath(ff.name) for ff in f] for f in
               args.factor_bigwigs]

    if args.factor_bigwigs_list_file:
        bws = [
            [os.path.abspath(l.rstrip()) for l in f] for f in
            args.factor_bigwigs_list_file
            ]

    json_str = create_json(bigwigs_list=bws, args=args)
    print json_str


if __name__ == '__main__':
    main()

process MTX_TO_H5AD_STAR {
    tag "$meta.id"
    label 'process_medium'

    conda "conda-forge::scanpy==1.10.2 conda-forge::python-igraph conda-forge::leidenalg"
    container "community.wave.seqera.io/library/scanpy:1.10.2--e83da2205b92a538"

    input:
    tuple val(meta), path(inputs)
    path star_index

    output:
    tuple val(meta2), path("${meta.id}/*h5ad"), emit: h5ad
    path  "versions.yml"                      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    // Get a file to check input type. Some aligners bring arrays instead of a single file.
    def input_to_check = (inputs instanceof String) ? inputs : inputs[0]

    // check input type of inputs
    input_type   = (input_to_check.toUriString().contains('unfiltered') || input_to_check.toUriString().contains('raw')) ? 'raw' : 'filtered'
    meta2        = meta + [input_type: input_type]

    template 'mtx_to_h5ad_star.py'

    stub:
    """
    mkdir ${meta.id}
    touch ${meta.id}/${meta.id}_matrix.h5ad
    touch versions.yml
    """
}

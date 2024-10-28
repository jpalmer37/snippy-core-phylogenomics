process roary {
    tag "roary"

    label 'medium'

    publishDir path: "${params.outdir}/roary", mode: "copy"

    input:
    path(gff_folder)

    output:
    path "roary_output", emit: roary_dir
    path "roary_output/gene_presence_absence.csv", emit: gene_presence_absence
    path "roary_output/core_gene_alignment.aln", emit: core_gene_alignment, optional: true
    path "roary_provenance.yml", emit: provenance

    script:
    """
    # Provenance tracking
    printf -- "- process_name: roary\\n" > roary_provenance.yml
    printf -- "  tools: \\n  - tool_name: roary\\n    tool_version: \$(roary -w 2>&1 | grep 'Version' | cut -d' ' -f2)\\n" >> roary_provenance.yml

    # Run Roary
    roary -p ${task.cpus} -f roary_output -e -n -v ${gff_folder}/*.gff

    # Check if core gene alignment was created (it might not be if there are no core genes)
    if [ ! -f roary_output/core_gene_alignment.aln ]; then
        echo "No core gene alignment was created. This is normal if there are no core genes."
    fi
    """
}
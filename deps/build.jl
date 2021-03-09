const BASEDIR="../input"
const DOCDIR="../doc"

const rules_url="https://rulebasedintegration.org/NotebookRuleFiles/Rubi-4.16.1.0.zip"
const doc_url="https://rulebasedintegration.org/PdfRuleFiles/Rubi-4.16.1.0.zip"

if Sys.isunix() && Sys.KERNEL != :FreeBSD
    function unpack_cmd(file, directory, extension, secondary_extension)
        if extension == ".zip"
            return (`unzip -x $file -d $directory`)
        end
        throw(ArguementError("I don't know how to unpack $file"))
    end
end

if Sys.KERNEL == :FreeBSD
    # The `tar` on FreeBSD can auto-detect the archive format via libarchive.
    # The supported formats can be found in libarchive-formats(5).
    # For NetBSD and OpenBSD, libarchive is not available.
    # For macOS, it is. But the previous unpack function works fine already.
    function unpack_cmd(file, dir, ext, secondary_ext)
        tar_args = ["--no-same-owner", "--no-same-permissions"]
        return pipeline(
            `/bin/mkdir -p $dir`,
            `/usr/bin/tar -xf $file -C $dir $tar_args`)
    end
end

if Sys.iswindows()
    const exe7z = joinpath(Sys.BINDIR, "7z.exe")

    function unpack_cmd(file,directory,extension,secondary_extension)
        if (extension == ".zip" || extension== ".gz" || extension == ".7z" || extension == ".tar" ||
                (extension == ".exe" && secondary_extension == ".7z"))
            return (`$exe7z x $file -y -o$directory`)
        end
        throw(ArguementError("I don't know how to unpack $file"))
    end
end

"""
    unpack(f; keep_originals=false)
Extracts the content of an archive in the current directory;
deleting the original archive, unless the `keep_originals` flag is set.
"""
function unpack(f; keep_originals=false)
    run(unpack_cmd(f, pwd(), last(splitext(f)), last(splitext(first(splitext(f))))))
    !keep_originals && rm(f)
end

function fix_names(root, names)
    for name in names
        old_name = joinpath(root, name)
        new_name = joinpath(root, replace(name, ' ' => '_'))
        if old_name != new_name
            mv(old_name, new_name)
        end
    end
end

function fix_names(dir)
    for (root, dirs, files) in walkdir(dir, topdown=false)
        fix_names(root, [dirs; files])
    end
end

function download_rules()
    rm(BASEDIR, recursive=true, force=true)
    mkdir(BASEDIR)
    cd(BASEDIR)
    filename = splitpath(rules_url)[end]
    download(rules_url, filename)
    unpack(filename)
    # cd("..")
end

function download_doc()
    rm(DOCDIR, recursive=true, force=true)
    mkdir(DOCDIR)
    cd(DOCDIR)
    filename = splitpath(doc_url)[end]
    download(doc_url, filename)
    unpack(filename)
    # cd("..")
end
    
download_rules()
download_doc()

fix_names(BASEDIR)
fix_names(DOCDIR)

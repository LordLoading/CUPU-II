import std.stdio;
import std.file;
import std.json;
import std.string;
import std.digest;
import obj;
import utils;

long textLen = 0;
long dataLen = 0;
long bssLen = 0;

void main(string[] args) {
    ObjFile[string] o;

    auto dirContent = dirEntries(".", "*.o", SpanMode.depth);

    if (args.length >= 2) {
        dirContent = dirEntries(args[1], "*.o", SpanMode.depth);
    }

    foreach (string filename; dirContent) {

        string content = cast(string) read(filename);
        JSONValue obj = parseJSON(content);
        o[obj["segment"].str] = ObjFile.fromJSON(obj);
    }

    o = fillSectionAddreses(o);
    o = fillLabels(o);
    o = applyRelocations(o);
    string merged = mergeObjFiles(o);
    writeln(merged);
    ubyte[] bytes = merged.fromHexString;
    if (args.length < 3) {
        std.file.write("out.bin", bytes);
    } else {
        std.file.write(args[2], bytes);
    }
}

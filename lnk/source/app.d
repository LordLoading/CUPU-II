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

void main() {
    ObjFile[string] o;

    foreach (string filename; dirEntries("test", "*.o", SpanMode.depth)) {

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
    std.file.write("t", bytes);
}

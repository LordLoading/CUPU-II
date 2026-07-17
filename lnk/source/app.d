import std.stdio;
import std.file;
import std.json;
import std.string;
import obj;

void main()
{
    ObjFile[] o;

    foreach(string filename; dirEntries("test", "*.o", SpanMode.depth)) {
        if (!filename.endsWith(".o")) continue;

        string content = cast(string) read(filename);
        JSONValue obj = parseJSON(content);
        o ~= ObjFile.fromJSON(obj);
    }

    writeln(o);
}

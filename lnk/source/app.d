import std.stdio;
import std.file;
import std.json;
import obj;

void main()
{
    // string content = cast(string) read("test/a.o");
    // JSONValue o = parseJSON(content);
    // writeln(o["data"]["items"]);

    ObjFile[] o;

    foreach(string filename; dirEntries("test", "*.o", SpanMode.depth)) {
        string content = cast(string) read(filename);
        JSONValue obj = parseJSON(content);
        o ~= ObjFile.fromJSON(obj);
    }

    writeln(o);

}

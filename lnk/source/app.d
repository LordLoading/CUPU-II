import std.stdio;
import std.file;
import std.json;
import obj;

void main()
{
    string content = cast(string) read("assembleme.o");
    writeln(content);
    JSONValue o = parseJSON(content);
    writeln(o["data"]["items"]);
}

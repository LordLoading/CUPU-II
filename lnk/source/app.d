import std.stdio;
import std.file;
import utils;

void main()
{
    string content = cast(string) read("assembleme.o");
    writeln(content);
}

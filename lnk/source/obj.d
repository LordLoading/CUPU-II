struct Label
{
    string name;
    int offset;
    string section;
    bool global;
}

struct Relocation
{
    int offset;
    string label;
    string section;
    enum RelocType
    {
        inst,
        data,
        bss,
    }
}

struct ObjFile
{
    string fileName;
    string segment;
    string text;
    string data;
    string bss;
    Label[] labels;
    Relocation[] relocations;
}

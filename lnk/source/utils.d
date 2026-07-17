import obj;
import app;
import std.string;
import std.stdio;
import std.algorithm;

ObjFile[string] fillSectionAddreses(ObjFile[string] o) {
    app.textLen += o["main"].text.length / 2;

    foreach (ObjFile oFile; o) {
        if (oFile.segment == "main") {
            continue;
        }

        o[oFile.segment].textAddress = app.textLen;
        app.textLen += oFile.text.length / 2;
    }

    app.dataLen += o["main"].data.length / 2;
    o["main"].dataAddress = app.textLen;

    foreach (ObjFile oFile; o) {
        if (oFile.segment == "main") {
            continue;
        }

        o[oFile.segment].dataAddress = app.dataLen + app.textLen;
        app.dataLen += oFile.data.length / 2;
    }

    app.bssLen += o["main"].bss.length / 2;
    o["main"].bssAddress = app.dataLen + app.textLen;

    foreach (ObjFile oFile; o) {
        if (oFile.segment == "main") {
            continue;
        }

        o[oFile.segment].bssAddress = app.bssLen + app.dataLen + app.textLen;
        app.bssLen += oFile.bss.length / 2;
    }

    return o;
}

ObjFile[string] fillLabels(ObjFile[string] o) {
    foreach (ObjFile oFile; o) {
        foreach (i, Label label; oFile.labels) {
            if (label.section == "text") {
                label.address = oFile.textAddress + label.offset;
            } else if (label.section == "data") {
                label.address = oFile.dataAddress + label.offset;
            } else if (label.section == "bss") {
                label.address = oFile.bssAddress + label.offset;
            }

            o[oFile.segment].labels[i] = label;
        }
    }

    return o;
}

ObjFile[string] applyRelocations(ObjFile[string] o) {
    foreach (ObjFile oFile; o) {
        foreach (i, Relocation reloc; oFile.relocations) {
            Label label;
            string[] labelStr = split(reloc.label, ".");
            if (labelStr.length == 2) {
                foreach (Label l; o[labelStr[0]].labels) {
                    if (l.name == labelStr[1]) {
                        label = l;
                        break;
                    }
                }
            } else {
                foreach (Label l; o[oFile.segment].labels) {
                    if (l.name == labelStr[0]) {
                        label = l;
                        break;
                    }
                }
            }

            if (reloc.section == "text") {
                if (reloc.relocType == RelocType.uimm) {
                    ubyte[] bytes = (cast(ubyte*)&label.address)[0 .. label.address.sizeof];
                    string hex = bytes[2 .. 4].map!(b => format("%02X", b)).join;
                    o[oFile.segment].text = o[oFile.segment].text.replace(reloc.offset * 2, reloc.offset * 2 + 4, hex);
                } else if (reloc.relocType == RelocType.imm) {
                    ubyte[] bytes = (cast(ubyte*)&label.address)[0 .. label.address.sizeof];
                    string hex = bytes[0 .. 2].map!(b => format("%02X", b)).join;
                    o[oFile.segment].text = o[oFile.segment].text.replace(reloc.offset * 2, reloc.offset * 2 + 4, hex);
                }
            } else if (reloc.section == "data") {
                if (reloc.relocType == RelocType.val) {
                    ubyte[] bytes = (cast(ubyte*)&label.address)[0 .. label.address.sizeof];
                    string hex = bytes[0 .. 4].map!(b => format("%02X", b)).join;
                    o[oFile.segment].text = o[oFile.segment].text.replace(reloc.offset * 2, reloc.offset * 2 + 8, hex);
                }
            } else if (reloc.section == "bss") {
                if (reloc.relocType == RelocType.val) {
                    ubyte[] bytes = (cast(ubyte*)&label.address)[0 .. label.address.sizeof];
                    string hex = bytes[0 .. 2].map!(b => format("%02X", b)).join;
                    o[oFile.segment].text = o[oFile.segment].text.replace(reloc.offset * 2, reloc.offset * 2 + 8, hex);
                }
            }
        }
    }
    return o;
}

string mergeObjFiles(ObjFile[string] o) {
    string merged;

    merged ~= o["main"].text;
    foreach (ObjFile oFile; o) {
        if (oFile.segment != "main") {
            merged ~= oFile.text;
        }
    }

    merged ~= o["main"].data;
    foreach (ObjFile oFile; o) {
        if (oFile.segment != "main") {
            merged ~= oFile.data;
        }
    }

    merged ~= o["main"].bss;
    foreach (ObjFile oFile; o) {
        if (oFile.segment != "main") {
            merged ~= oFile.bss;
        }
    }

    return merged;
}

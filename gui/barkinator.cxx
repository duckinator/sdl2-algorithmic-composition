#include "barkinator.hxx"
#include "bk_oscillator.hxx"
#include "../src/synth/synth.h"

static BarkinatorUI *ui;

BarkinatorUI::BarkinatorUI()
{
    window = new Fl_Double_Window(350, 600, "Window");
}

void synth_creation_callback(Synth *synth)
{
    static int idx = 0;
    ui->oscillators[idx] = new BkOscillator(idx, synth);
    idx += 1;
}

int main(int argc, char *argv[])
{
    ui = new BarkinatorUI();
    synth_register_callback(synth_creation_callback);
    if (!synth_setup(argc, argv)) {
        return 1;
    }
    ui->window->end();

    ui->window->show(argc, argv);

    return Fl::run();
}

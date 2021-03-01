use std::f64::consts::PI;
use std::process::Command;
use std::thread;
use std::time;
use structopt::StructOpt;

/// Downloads maps tiles from a tile server that supports z/x/y. Requires wget
#[derive(StructOpt, Debug)]
#[structopt(name = "tile-downloader")]
struct Opt {
    /// Latitude of the starting corner
    #[structopt(long)]
    lat_start: f64,

    /// Longitude of the starting corner
    #[structopt(long)]
    lon_start: f64,

    /// Latitude of the final corner
    #[structopt(long)]
    lat_end: f64,

    /// Longitude of the final corner
    #[structopt(long)]
    lon_end: f64,

    /// URL of the tile server. Must accept z/x/y.png
    #[structopt(long)]
    url: String,

    #[structopt(long, default_value = "10")]
    min_zoom: i32,

    #[structopt(long, default_value = "20")]
    max_zoom: i32,
}

fn get_tile(lat: f64, lon: f64, zoom: i32) -> (i32, i32, i32) {
    let x = ((lon + 180.0) / 360.0 * (1 << zoom) as f64).floor() as i32;

    let lat_rad = lat * PI / 180.0;
    let y = ((1.0 - (lat_rad.tan()).asinh() / PI) / 2.0 * (1 << zoom) as f64).floor() as i32;
    return (zoom, x as i32, y as i32);
}

fn main() {
    let args = Opt::from_args();

    let lat_start = args.lat_start;
    let lon_start = args.lon_start;
    let lat_end = args.lat_end;
    let lon_end = args.lon_end;
    let url = args.url;

    for zoom in args.min_zoom..=args.max_zoom {
        let start = get_tile(lat_start, lon_start, zoom);
        let end = get_tile(lat_end, lon_end, zoom);

        let start_x;
        let start_y;
        let end_x;
        let end_y;

        if start.1 > end.1 {
            start_x = end.1;
            end_x = start.1;
        } else {
            start_x = start.1;
            end_x = end.1;
        }

        if start.2 > end.2 {
            start_y = end.2;
            end_y = start.2;
        } else {
            start_y = start.2;
            end_y = end.2;
        }

        for x in start_x..=end_x {
            Command::new("mkdir")
                .arg("-p")
                .arg(format!("tiles/{}/{}", zoom, x))
                .spawn()
                .expect(format!("Failed to create tiles/{}/{}", zoom, x).as_str());
            for y in start_y..=end_y {
                //println!("{}/{}/{}/{}.png", url, zoom, x, y);
                let status = Command::new("wget")
                    .arg(format!("{}/{}/{}/{}.png", url, zoom, x, y))
                    .arg("-q")
                    .arg("-O")
                    .arg(format!("tiles/{}/{}/{}.png", zoom, x, y))
                    .status()
                    .unwrap();

                if !status.success() {
                    println!("Failed to download tiles/{}/{}/{}.png", zoom, x, y);
                }
                //  .spawn()
                //  .expect(format!("Failed to download tiles/{}/{}/{}.png", zoom, x, y).as_str());
                thread::sleep(time::Duration::from_millis(50));
            }
        }
    }
}

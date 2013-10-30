#import "PieDemoViewController.h"

#import "PieSeriesDelegate.h"

#import <ILCharts/ILChartView.h>
#import <ILCharts/Series/ILPieSeries.h>
#import <ILCharts/Series/ILPieSeriesDelegate.h>

@interface PieDemoViewController ()
@end

@implementation PieDemoViewController
{
    ILPieSeries       *_pieSeries;
    PieSeriesDelegate *_pieDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)setupChart
{
    _pieSeries   = [ILPieSeries new];
    
    _pieDelegate = [PieSeriesDelegate new];

    _pieSeries.delegate   = _pieDelegate;

    [self.chartView addSeries:_pieSeries];
}

- (IBAction)reloadAction:(id)sender
{
    [_pieDelegate refreshData];

    [_chartView reloadData];
}

@end

#import "FirstViewController.h"

#import "BarSeriesDelegate.h"

#import <ILCharts/ILChartView.h>
#import <ILCharts/Series/ILBarsSeries.h>
#import <ILCharts/Series/ILBarsSeriesDelegate.h>

#import <ILCharts/Series/ILValuesSeries.h>

@interface FirstViewController ()
@end

@implementation FirstViewController
{
    ILBarsSeries       *_barSeries;
    BarSeriesDelegate  *_barDelegate;
    
    BOOL _barsOrientationHorizontal;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initDelegates];
    [self setupChart];
    
    [self.chartView reloadData];
}

- (void)initDelegates
{
    _barDelegate = [BarSeriesDelegate new];
}

- (void)setupChart
{
    _barSeries = [ILBarsSeries new];

    _barSeries.delegate   = _barDelegate;
    _barSeries.horizontal = _barsOrientationHorizontal;
    
    [self.chartView addSeries: _barSeries];
    
    self.chartView.scrollFromTop = YES;

   [self setupChartContentSize];

    ILValuesSeries *valuesSeries = [ILValuesSeries new];
    valuesSeries.dataSource = _barSeries;
    [self.chartView addSeries: valuesSeries];
}

- (void)setupChartContentSize
{
    CGFloat chartWidth  = _barsOrientationHorizontal ? 700 : 7000;
    CGFloat chartHeight = _barsOrientationHorizontal ? 7000: 700;

    self.chartView.contentSize = CGSizeMake( chartWidth, chartHeight);
}

#pragma mark- Actions

- (IBAction)onFlipBarsOrientation:(id)sender
{
    _barsOrientationHorizontal = !_barsOrientationHorizontal;

    _barSeries.horizontal = _barsOrientationHorizontal;

    [self setupChartContentSize];

    [self.chartView reloadData];
}

- (IBAction)onReloadChart:(id)sender
{
    [_barDelegate.valuesDictonary removeAllObjects];

    [self.chartView reloadData];
}

@end
